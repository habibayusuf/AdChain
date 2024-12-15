;; Analytics Contract

(define-map ad-performance
  { ad-id: uint }
  {
    views: uint,
    clicks: uint,
    conversions: uint
  }
)

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u401))
(define-constant err-not-found (err u404))

(define-public (record-view (ad-id uint))
  (let
    (
      (performance (default-to { views: u0, clicks: u0, conversions: u0 } (map-get? ad-performance { ad-id: ad-id })))
    )
    (ok (map-set ad-performance
      { ad-id: ad-id }
      (merge performance { views: (+ (get views performance) u1) })
    ))
  )
)

(define-public (record-click (ad-id uint))
  (let
    (
      (performance (default-to { views: u0, clicks: u0, conversions: u0 } (map-get? ad-performance { ad-id: ad-id })))
    )
    (ok (map-set ad-performance
      { ad-id: ad-id }
      (merge performance { clicks: (+ (get clicks performance) u1) })
    ))
  )
)

(define-public (record-conversion (ad-id uint))
  (let
    (
      (performance (default-to { views: u0, clicks: u0, conversions: u0 } (map-get? ad-performance { ad-id: ad-id })))
    )
    (ok (map-set ad-performance
      { ad-id: ad-id }
      (merge performance { conversions: (+ (get conversions performance) u1) })
    ))
  )
)

(define-read-only (get-ad-performance (ad-id uint))
  (ok (unwrap! (map-get? ad-performance { ad-id: ad-id }) err-not-found))
)

