# Credentials that are not ssh keys: aws, kubectl, snowflake, model providers.
# ssh keys live next to the hosts that use them, in config/ssh/.
{lib, ...}: {
  sops.secrets = lib.genAttrs [
    "aws/config"
    "aws/credentials"
    "k8s/config"
    "key/cube/snow"
    "env/avante"
    "env/openrouter"
    "env/openrouter-cube"
    "env/zai"
    "env/vantage"
    "env/instance-vantage"
    "env/context7"
  ] (_: {mode = "0600";});
}
