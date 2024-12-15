;; Ad Token Contract

(define-fungible-token ad-token)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u401))
(define-constant err-insufficient-balance (err u402))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? ad-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-owner-only)
    (ft-transfer? ad-token amount sender recipient)
  )
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance ad-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply ad-token))
)

