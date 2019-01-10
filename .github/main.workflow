workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for Zeit"]
}

action "GitHub Action for Zeit" {
  uses = "actions/zeit-now@9fe84d557939d277e0d98318b625bd48d364a89b"
  args = "--token $ENV_VARIABLE_NAME"
  secrets = ["ENV_VARIABLE_NAME"]
}
