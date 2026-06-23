---
name: ci-pipeline
description: Génère ou met à jour les workflows GitHub Actions (CI build/test/scan + CD avec gate manuel prod). Explique chaque étape et n'active jamais un déploiement prod automatique.
---

# Skill : ci-pipeline

Objectif : produire des pipelines GitHub Actions clairs et sûrs, en séparant CI et CD.

## Étapes à suivre
1. Identifier la stack (.NET 8, microservices, Docker) et l'emplacement des Dockerfiles.
2. Générer `.github/workflows/ci.yml` : push/PR sur main → checkout, setup-dotnet, restore, build, test ; job séparé build image + scan Trivy.
3. Générer `.github/workflows/cd.yml` : après CI réussi → déploiement pré-prod auto, puis prod derrière `environment: production` (approbation humaine).
4. Commenter chaque étape pour un public débutant.

## Garde-fous
- JAMAIS de déploiement prod sans gate manuel / approbation humaine.
- Jamais de secret en clair : utiliser ${{ secrets.NOM }}.
- Le scan de sécurité bloque la chaîne si faille critique.