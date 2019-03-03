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
      :parameters (?r - robot ?lA - location ?lB - location)
      :precondition (and (at ?r ?lA) (free ?r) (no-robot ?lB) (connected ?lA ?lB))
      :effect (and (no-robot ?lA) (not (at ?r ?lA)) (at ?r ?lB) (not (no-robot ?lB)))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?lA - location ?lB - location)
      :precondition (and (at ?r ?lA) (at ?p ?lA) (free ?r) (no-robot ?lB) (no-pallette ?lB) (connected ?lA ?lB))
      :effect (and (no-robot ?lA) (no-pallette ?lA) (not (at ?r ?lA)) (not (at ?p ?lA)) (at ?r ?lB) (at ?p ?lB) (not (no-robot ?lB)) (not (no-pallette ?lB)) (connected ?lA ?lB))
   )


)
