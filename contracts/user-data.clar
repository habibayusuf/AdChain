;; User Data Contract

(define-map user-data
  { user: principal }
  {
    demographics: (list 5 (string-ascii 20)),
    data-sharing-enabled: bool
  }
)

(define-constant err-unauthorized (err u401))

(define-public (set-user-data (demographics (list 5 (string-ascii 20))) (data-sharing-enabled bool))
  (ok (map-set user-data
    { user: tx-sender }
    {
      demographics: demographics,
      data-sharing-enabled: data-sharing-enabled
    }
  ))
)

(define-public (toggle-data-sharing)
  (let
    (
      (user-info (default-to { demographics: (list), data-sharing-enabled: false } (map-get? user-data { user: tx-sender })))
    )
    (ok (map-set user-data
      { user: tx-sender }
      (merge user-info { data-sharing-enabled: (not (get data-sharing-enabled user-info)) })
    ))
  )
)

(define-read-only (get-user-data (user principal))
  (ok (unwrap! (map-get? user-data { user: user }) (err u404)))
)

