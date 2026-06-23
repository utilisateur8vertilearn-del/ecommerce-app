---
name: gen-tests
description: Génère des tests pour l'ecommerce-app (.NET) — unitaires xUnit et intégration WebApplicationFactory/Testcontainers. Vise les cas limites, n'invente pas de comportement, laisse l'humain valider la couverture.
---

# Skill : gen-tests

## Étapes à suivre
1. Repérer quoi tester : cas nominal, limites (vide/null/0/négatif), erreurs (404/400).
2. Créer le projet de test si besoin (`dotnet new xunit`), ajouter Moq / Mvc.Testing / Testcontainers.
3. Tests unitaires xUnit : 1 méthode = 1 cas, structure Arrange/Act/Assert, `[Fact]`/`[Theory]`, dépendances mockées (Moq).
4. Tests d'intégration : `WebApplicationFactory<Program>` (vrais endpoints) + Testcontainers (base jetable).
5. Lancer `dotnet test` + couverture Coverlet ; proposer les cas manquants.

## Garde-fous
- Ne jamais affaiblir un test pour le faire passer.
- Aucun secret ni environnement de prod dans les tests.
- « Couverture suffisante » = décision humaine.