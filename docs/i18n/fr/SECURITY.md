# Politique de sécurité

Langue : [English](../../../SECURITY.md) | [한국어](../ko/SECURITY.md) | [Español](../es/SECURITY.md) | Français | [हिन्दी](../hi/SECURITY.md) | [简体中文](../zh-CN/SECURITY.md)

Cette politique de sécurité est la politique par défaut des dépôts appartenant à 0disoft. Si un dépôt possède son propre `SECURITY.md`, la politique propre à ce dépôt prévaut.

## Dépôts pris en charge

Les signalements de sécurité sont examinés pour les dépôts maintenus activement.

Les dépôts archivés, expérimentaux, obsolètes ou non maintenus peuvent ne pas recevoir de correctifs de sécurité.

Sauf indication contraire dans un dépôt, le travail de sécurité est effectué dans la mesure du possible pour la branche par défaut et la dernière version publique, si le dépôt utilise des releases.

## Exigences de sécurité pour les contributions

Les changements qui introduisent ou modifient l’authentification, l’autorisation, la cryptographie, la gestion des secrets, le traitement des paiements, le traitement des données personnelles ou un comportement exposé au réseau nécessitent une revue supplémentaire par le mainteneur.

## Politique de cryptographie

Pour tout changement qui introduit, modifie ou dépend d’un comportement cryptographique :

- N’implémentez pas votre propre cryptographie et ne combinez pas directement des primitives cryptographiques sans l’approbation explicite du mainteneur et une revue de sécurité appropriée.
- Privilégiez les protocoles établis, les bibliothèques bien maintenues et les implémentations inscrites dans un processus de standardisation.
- La cryptographie symétrique et les fonctions de hachage restent autorisées. Utilisez du chiffrement authentifié moderne, de l’authentification de messages et des primitives de hachage via des bibliothèques maintenues.
- Les choix cryptographiques doivent être configurables et remplaçables lorsque c’est possible. Évitez de figer les algorithmes dans le code lorsqu’une négociation de protocole ou une configuration de bibliothèque est disponible.

### Cryptographie à clé publique et cryptographie post-quantique

- Pour les nouvelles fonctionnalités de chiffrement à clé publique, d’établissement de clés ou de signature numérique, privilégiez la cryptographie post-quantique standardisée par le NIST lorsqu’une prise en charge prête pour la production existe.
- Privilégiez ML-KEM pour les nouveaux mécanismes d’établissement de clés, et ML-DSA ou SLH-DSA pour les nouvelles signatures numériques lorsque ces choix conviennent au protocole et à l’environnement d’exécution.
- Suivez l’évolution des autres algorithmes standardisés par le NIST ou engagés dans un processus de standardisation, notamment FN-DSA et HQC, à mesure qu’ils gagnent en maturité.
- Les configurations hybrides combinant cryptographie classique et post-quantique sont autorisées lorsqu’elles sont nécessaires pour l’interopérabilité, à condition de suivre un protocole, un profil ou un standard reconnu et pris en charge par un fournisseur.
- L’usage existant de RSA, Diffie-Hellman, ECDH, ECDSA ou EdDSA peut être conservé lorsqu’il est nécessaire pour la compatibilité. En revanche, les nouveaux secrets à longue durée de vie, les nouvelles racines de confiance à longue durée de vie et les nouveaux protocoles cryptographiques doivent être prêts pour une transition post-quantique lorsque c’est possible.
- N’utilisez pas de schémas post-quantiques non standard, expérimentaux ou réservés à la recherche dans du code de production sans l’approbation explicite du mainteneur et une revue de sécurité.

L’objectif n’est pas d’interdire immédiatement toute la cryptographie existante. L’objectif est d’éviter d’ajouter des dépendances de clé publique inutilement vulnérables aux attaques quantiques et de garder les composants cryptographiques remplaçables.

## Politique de stockage des mots de passe

Si un projet stocke des mots de passe d’utilisateurs :

- Ne stockez pas les mots de passe en clair ni avec un chiffrement réversible.
- Ne hachez pas directement les mots de passe avec des fonctions de hachage rapides et généralistes comme MD5, SHA-1, SHA-256 ou SHA-512.
- Privilégiez Argon2id pour le nouveau hachage de mots de passe.
- Utilisez un sel (salt) unique et généré aléatoirement pour chaque mot de passe. Pour le hachage de mots de passe avec Argon2id, un sel de 16 octets est recommandé.
- Utilisez des bibliothèques maintenues et des formats standards de hachage de mots de passe lorsque c’est possible.
- Les paramètres d’Argon2id doivent être configurables et réexaminés à mesure que le matériel et les contraintes de déploiement évoluent.
- Comme base minimale, utilisez au moins les paramètres Argon2id recommandés par l’OWASP, sauf si une politique propre au dépôt définit des paramètres plus stricts : 19 Mio de mémoire, 2 itérations et 1 degré de parallélisme.
- Si Argon2id n’est pas disponible, utilisez scrypt lorsque c’est possible. Pour les systèmes hérités, bcrypt peut être conservé temporairement avec un facteur de travail approprié et un plan de migration. Si la conformité FIPS-140 est requise, utilisez PBKDF2-HMAC-SHA-256 avec un facteur de travail approuvé.
- N’utilisez pas de hachages rapides, de hachages sans sel ni de schémas personnalisés de hachage de mots de passe.
- Stockez l’algorithme, les paramètres, le sel et la version du hachage avec chaque hash de mot de passe afin de pouvoir les mettre à niveau au fil du temps.

## Politique relative aux tokens, clés API et secrets

Pour les tokens générés par machine, les clés API, les codes de récupération et les secrets similaires :

- Générez les secrets avec un générateur de nombres aléatoires cryptographiquement sûr.
- Ne stockez pas les clés API, tokens d’accès, tokens de rafraîchissement, tokens de session ou codes de récupération sous leur forme brute, sauf besoin opérationnel clair.
- Privilégiez le stockage d’un hash avec clé, d’un hash ou d’un vérificateur non réversible lorsque la récupération du texte original n’est pas nécessaire.
- Les secrets ne doivent pas être commités dans le dépôt, inclus dans les logs, exposés dans les messages d’erreur ni stockés dans les données de test.
- Utilisez un gestionnaire de secrets, un stockage de secrets propre à l’environnement ou le mécanisme de secrets chiffrés fourni par la plateforme pour les secrets opérationnels.

## Sécurité des dépendances et de la chaîne d’approvisionnement

- Gardez les dépendances raisonnablement à jour.
- Les changements de dépendances ayant un impact sur la sécurité doivent être examinés avant une release.
- N’ajoutez pas de dépendances liées à la cryptographie, l’authentification, l’autorisation, la sérialisation, le rendu de templates ou l’analyse de données réseau sans revue du mainteneur.

## Signaler une vulnérabilité

Ne signalez pas les vulnérabilités de sécurité via des issues, pull requests ou discussions publiques.

Si le dépôt a activé le signalement privé de vulnérabilités GitHub, utilisez cette option.

Si le signalement privé de vulnérabilités n’est pas disponible, ne publiez pas publiquement les détails d’exploitation. Utilisez un moyen de contact privé indiqué dans le dépôt ou sur le profil GitHub du mainteneur.

Lorsque vous signalez une vulnérabilité, incluez :

- le dépôt concerné
- la version, la branche ou le commit concerné, si vous les connaissez
- une description claire du problème
- les étapes permettant de reproduire le problème
- l’impact potentiel
- toute mesure d’atténuation suggérée, si disponible

## Traitement

Les signalements seront examinés de bonne foi.

Le mainteneur peut demander des informations supplémentaires, préparer un correctif, coordonner la divulgation ou déterminer que le problème signalé ne constitue pas une vulnérabilité de sécurité.

Évitez de divulguer publiquement le problème avant qu’un correctif ou une mesure d’atténuation ait été préparé, sauf si le mainteneur ne répond pas pendant une période déraisonnablement longue.
