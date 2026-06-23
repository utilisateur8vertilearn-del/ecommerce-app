---
name: open-pr
description: Pousse la branche courante et ouvre une Pull Request GitHub avec un titre clair, une description structurée et une checklist. Demande validation avant de pousser.
---

# Skill : open-pr

Objectif : transformer une branche de travail en Pull Request bien documentée (via `gh`).

## Étapes à suivre
1. Vérifier la branche (`git branch --show-current`). Si on est sur `main`, REFUSER et proposer une branche.
2. Récapituler : `git log --oneline main..HEAD`.
3. ⚠️ Demander confirmation, puis `git push -u origin <branche>`.
4. Rédiger un corps : Contexte / Changements / Tests / Checklist (pas de secret, tests OK, impact infra).
5. Créer la PR : `gh pr create --title "<titre>" --body "<corps>"` et afficher l'URL.

## Garde-fous
- Ne JAMAIS merger automatiquement (`gh pr merge`).
- Vérifier qu'aucun secret n'est inclus avant le push.