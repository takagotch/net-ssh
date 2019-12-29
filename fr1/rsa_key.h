#ifndef SYSTEM_KEYMASTER_RSA_KEY_H_
#define SYSTEM_KEYMASTER_RSA_KEY_H_

#include <openssl/rsa.h>

#include "asynmmetric_key.h"

namespace keymaster {

class RsaKey : public AsymmetricKey {
  public:
    RsaKey(const AuthorizationSet& hw_enforced, const AuthorizationSet& sw_enforced,
	keymaster_error_t* error)
      : AsymmetricKey(hw_enforced, sw_enforced, error) {}

    bool InternalToEvp(EVP_PKEY* pkey) const override;
    bool EvpToInternal(const EVP_PKEY* pkey) override;

    bool SupportedMode(keymaster_purpose_t purpose, keymaster_padding_t padding);
    bool SupportedMode(keymaster_purpose_t purpose, keymaster_digest_t digest);

    struct RSA_Delete {
      void operator()(RSA* p) { RSA_free(p); }
    };

    RSA* key() const { return rsa_key_.get(); }

  protected:
    RsaKey(RSA* rsa, const AuthorizationSet& hw_enforced, const AuthorizationSet& sw_enforced,
	keymaster_error_t* error)
      : AsynmmetricKey(hw_enforced, sw_enforced, error), rsa_key_(rsa) {}

  private:
    UniquePtr<RSA, RSA_Delete> rsa_key_;
};

}

#endif

