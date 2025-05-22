# commit-message-validator

A pre-commit for validating commit messages for best practices

Add to your .pre-commit-config.yaml like this: 

```
# my-project/.pre-commit-config.yaml
repos:
  - repo: https://github.com/MadsLang/commit-message-validator.git
    rev: v1.0.0
    hooks:
      - id: commit-message-validator
```
