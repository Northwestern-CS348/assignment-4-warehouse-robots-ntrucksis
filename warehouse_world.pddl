(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )
   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?ls - location ?le - location)
      :precondition (and (at ?r ?ls) (free ?r) (no-robot ?le) (connected ?ls ?le))
      :effect (and (no-robot ?ls) (not (at ?r ?ls)) (at ?r ?le) (not (no-robot ?le)))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?ls - location ?le - location)
      :precondition (and (at ?r ?ls) (at ?p ?ls) (free ?r) (no-robot ?le) (no-pallette ?le) (connected ?ls ?le))
      :effect (and (no-robot ?ls) (no-pallette ?ls) (not (at ?r ?ls)) (not (at ?p ?ls)) (at ?r ?le) (at ?p ?le) (not (no-robot ?le)) (not (no-pallette ?le)) (connected ?ls ?le))
   )
   
   (:action moveItemFromPallette
	  :parameters (?l - location ?p - pallette ?si - saleitem ?s - shipment ?o - order)
	  :precondition (and (started ?s) (at ?p ?l) (packing-at ?s ?l) (packing-location ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si))
	  :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
	:parameters (?s - shipment ?l - location ?o - order)
	:precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (not (available ?l)) (packing-location ?l))
	:effect (and (not (started ?s)) (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )  
)
