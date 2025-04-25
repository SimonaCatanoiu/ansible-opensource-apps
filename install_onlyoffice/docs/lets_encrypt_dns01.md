
# DNS-01 Challenge with Let's Encrypt for ONLYOFFICE

Using Let's Encrypt with the DNS-01 challenge allows you to issue valid TLS certificates **without exposing your server to the Internet**, as long as:

- You own a **public domain**.
- You use a **DNS provider that supports API access** (in this case, Cloudflare).
- Your ACME client (e.g., `certbot`) supports DNS verification via that API. -> The plugins for DNS verifications are automatically installed in this playbook.

## ❓ When To Use DNS-01 Validation?

If your server:
- Is **on a private IP** or behind NAT.
- Cannot open port 80/443 to the internet.
- Still needs a **trusted TLS certificate** for secure HTTPS.

=> then DNS-01 is the best approach.

## 🌐 Cloudflare Setup

**Domain Setup**
- Go to [Cloudflare Dashboard](https://dash.cloudflare.com)
- Go to your hosting account → `Add a domain`
- Enter an existing domain
- Select `Manually enter DNS records`

**Get Cloudflare API Key**
- Visit: [https://dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens)
- Click `Create Token` → Template: `Edit zone DNS`
- Select `Zone: your domain`
- Save the generated key (`API_KEY_CLOUDFLARE`)

**Update your Ansible variables**
   ```yaml
   tls_with_lets_encrypt: true
   letsencrypt_email: "your_email@example.com"
   lets_encrypt_dns_verification: true
   cloudflare_api_token: "CLOUDFLARE_API_KEY"
   ```


## 🛠️ How It Works

When `lets_encrypt_dns_verification` is set to `true`, the playbook:
- Uses a custom script (`custom_dns_verification_certbot.sh`)
- Automates the certificate issuance via Cloudflare API
- Installs and configures the cert into NGINX for ONLYOFFICE

## 📌 Notes

- Domain must already be configured in Cloudflare.
- Propagation time for DNS records can vary slightly, usually under 60 seconds.
- If using custom DNS or multiple zones, ensure the API token has permissions for the correct zone.
