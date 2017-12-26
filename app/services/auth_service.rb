class AuthService
  TOKEN_LIFETIME = 15.minutes

  class << self
    def encode(data)
      payload = { data: data, exp: expiration_time  }
      JWT.encode(payload, secret_key, algorithm_type)
    end

    def decode(token)
      JWT.decode(token, secret_key, true, { algorithm: algorithm_type }).first['data']
    end

    private

    def secret_key
      ENV["JWT_KEY"]
    end

    def algorithm_type
      'HS256'
    end

    def expiration_time
      Time.now.to_i + TOKEN_LIFETIME
    end
  end

end
