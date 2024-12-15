;; Ad Placement Contract

(define-data-var ad-counter uint u0)

(define-map ads
  { ad-id: uint }
  {
    advertiser: principal,
    content-hash: (buff 32),
    budget: uint,
    price-per-view: uint,
    target-demographics: (list 5 (string-ascii 20)),
    active: bool
  }
)

(define-map ad-views
  { ad-id: uint, user: principal }
  { views: uint }
)

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u401))
(define-constant err-not-found (err u404))

(define-public (create-ad (content-hash (buff 32)) (budget uint) (price-per-view uint) (target-demographics (list 5 (string-ascii 20))))
  (let
    (
      (ad-id (+ (var-get ad-counter) u1))
    )
    (map-set ads
      { ad-id: ad-id }
      {
        advertiser: tx-sender,
        content-hash: content-hash,
        budget: budget,
        price-per-view: price-per-view,
        target-demographics: target-demographics,
        active: true
      }
    )
    (var-set ad-counter ad-id)
    (ok ad-id)
  )
)

(define-public (deactivate-ad (ad-id uint))
  (let
    (
      (ad (unwrap! (map-get? ads { ad-id: ad-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender (get advertiser ad)) err-unauthorized)
    (ok (map-set ads
      { ad-id: ad-id }
      (merge ad { active: false })
    ))
  )
)

(define-public (record-ad-view (ad-id uint) (user principal))
  (let
    (
      (ad (unwrap! (map-get? ads { ad-id: ad-id }) err-not-found))
      (current-views (default-to { views: u0 } (map-get? ad-views { ad-id: ad-id, user: user })))
    )
    (asserts! (get active ad) err-not-found)
    (map-set ad-views
      { ad-id: ad-id, user: user }
      { views: (+ (get views current-views) u1) }
    )
    (ok true)
  )
)

(define-read-only (get-ad (ad-id uint))
  (ok (unwrap! (map-get? ads { ad-id: ad-id }) err-not-found))
)

(define-read-only (get-ad-views (ad-id uint) (user principal))
  (ok (default-to { views: u0 } (map-get? ad-views { ad-id: ad-id, user: user })))
)

