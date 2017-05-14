require 'jwt'
class AuthService

  class << self
    def encode(data)
      payload = { data: data, exp: expiration_time  }
      JWT.encode(payload, secret_key, algorith_type)
    end

    def decode(token)
      JWT.decode(token, secret_key, true, { algorithm: algorith_type }).first['data']
    end

    private

    def secret_key
      ENV["JWT_KEY"]
    end

    def algorith_type
      'HS256'
    end

    def expiration_time
      Time.now.to_i + 15 * 60
    end
  end

end
