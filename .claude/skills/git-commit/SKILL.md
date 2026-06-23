---
name: git-commit
description: Crée un commit Git propre au format Conventional Commits. Analyse les changements, propose un message clair, et demande TOUJOURS validation avant de commiter.
---

# Skill : git-commit

Objectif : produire un commit propre et lisible au format Conventional Commits.

## Étapes à suivre
1. Lancer `git status` puis `git diff` et résumer le changement en une phrase.
2. Indexer les bons fichiers (`git add`) — jamais de fichier de secret ni `.env`.
3. Rédiger le message : `type(scope): description` (types : feat, fix, docs, refactor, test, chore, ci, perf).
4. ⚠️ Afficher le message proposé et DEMANDER VALIDATION avant `git commit`.
5. Confirmer avec `git log -1 --oneline`.

## Garde-fous
- Jamais de `git push` dans ce skill.
- Si un secret est détecté dans le diff, STOPPER et alerter.