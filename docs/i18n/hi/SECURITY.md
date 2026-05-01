# सुरक्षा नीति

भाषा: [English](../../../SECURITY.md) | [한국어](../ko/SECURITY.md) | [Español](../es/SECURITY.md) | [Français](../fr/SECURITY.md) | हिन्दी | [简体中文](../zh-CN/SECURITY.md)

यह 0disoft के स्वामित्व वाले रिपॉज़िटरी के लिए डिफ़ॉल्ट सुरक्षा नीति है। यदि किसी रिपॉज़िटरी में अपना `SECURITY.md` है, तो उसी रिपॉज़िटरी की सुरक्षा नीति को प्राथमिकता दी जाएगी।

## समर्थित रिपॉज़िटरी

सुरक्षा रिपोर्ट उन रिपॉज़िटरी के लिए समीक्षा की जाती हैं जिनका सक्रिय रूप से रखरखाव किया जा रहा है।

Archived, experimental, deprecated या unmaintained रिपॉज़िटरी को सुरक्षा सुधार नहीं मिल भी सकते हैं।

जब तक किसी रिपॉज़िटरी में अलग से न बताया गया हो, सुरक्षा से जुड़ा काम default branch और नवीनतम public release के लिए best-effort आधार पर किया जाता है, यदि उस रिपॉज़िटरी में releases का उपयोग होता है।

## योगदानों के लिए सुरक्षा आवश्यकताएँ

ऐसे बदलाव जिनमें authentication, authorization, cryptography, secret handling, payment handling, personal data processing या network-exposed behavior को जोड़ा या बदला जाता है, उनके लिए मेंटेनर की अतिरिक्त समीक्षा आवश्यक है।

## क्रिप्टोग्राफी नीति

ऐसे किसी भी बदलाव के लिए जो cryptographic behavior जोड़ता है, बदलता है या उस पर निर्भर करता है:

- मेंटेनर की स्पष्ट अनुमति और उचित सुरक्षा समीक्षा के बिना अपनी cryptography लागू न करें और cryptographic primitives को सीधे जोड़कर अपना समाधान न बनाएँ।
- स्थापित protocols, अच्छी तरह maintained libraries और standards-track implementations को प्राथमिकता दें।
- Symmetric cryptography और hash functions का उपयोग अभी भी किया जा सकता है। Modern authenticated encryption, message authentication और hash primitives को maintained libraries के माध्यम से उपयोग करें।
- जहाँ व्यावहारिक हो, cryptographic choices configurable और replaceable होनी चाहिए। यदि protocol negotiation या library configuration उपलब्ध है, तो algorithms को code में hard-code करने से बचें।

### Public-Key Cryptography और PQC

- नई public-key encryption, key establishment या digital signature functionality के लिए, जहाँ production-ready support मौजूद हो, NIST-standardized post-quantum cryptography को प्राथमिकता दें।
- नए key establishment के लिए ML-KEM को प्राथमिकता दें। नई digital signatures के लिए, यदि वे protocol और runtime environment के अनुकूल हों, तो ML-DSA या SLH-DSA को प्राथमिकता दें।
- FN-DSA और HQC सहित अन्य NIST-standardized या standards-track algorithms की परिपक्वता पर नज़र रखें।
- Interoperability के लिए आवश्यक होने पर classical और post-quantum hybrid configurations की अनुमति है, बशर्ते वे किसी recognized protocol, profile या vendor-supported standard का पालन करें।
- Compatibility के लिए आवश्यक होने पर RSA, Diffie-Hellman, ECDH, ECDSA या EdDSA का मौजूदा उपयोग जारी रह सकता है। लेकिन नए long-lived secrets, long-lived trust roots और नए cryptographic protocol designs को जहाँ व्यावहारिक हो, post-quantum ready बनाया जाना चाहिए।
- मेंटेनर की स्पष्ट अनुमति और सुरक्षा समीक्षा के बिना non-standard, experimental या research-only post-quantum schemes को production code में उपयोग न करें।

उद्देश्य मौजूदा cryptography को तुरंत प्रतिबंधित करना नहीं है। उद्देश्य अनावश्यक रूप से quantum-vulnerable public-key dependencies जोड़ने से बचना और cryptographic components को replaceable बनाए रखना है।

## पासवर्ड स्टोरेज नीति

यदि कोई project user passwords store करता है:

- Passwords को plaintext में या reversible encryption के साथ store न करें।
- MD5, SHA-1, SHA-256 या SHA-512 जैसे fast general-purpose hash functions से passwords को सीधे hash न करें।
- नए password hashing के लिए Argon2id को प्राथमिकता दें।
- हर password के लिए unique और randomly generated salt का उपयोग करें। Argon2id password hashing के लिए 16-byte salt की सिफारिश की जाती है।
- जहाँ व्यावहारिक हो, maintained libraries और standard password hash formats का उपयोग करें।
- Argon2id parameters configurable होने चाहिए और hardware तथा deployment constraints बदलने पर उनकी समीक्षा की जानी चाहिए।
- जब तक repository-specific policy अधिक सख्त parameters न बताए, baseline के रूप में कम से कम OWASP-recommended minimum Argon2id settings का उपयोग करें: 19 MiB memory, 2 iterations और 1 degree of parallelism।
- यदि Argon2id उपलब्ध नहीं है, तो जहाँ संभव हो scrypt का उपयोग करें। Legacy systems में bcrypt को उचित work factor और migration plan के साथ अस्थायी रूप से रखा जा सकता है। यदि FIPS-140 compliance आवश्यक है, तो approved work factor के साथ PBKDF2-HMAC-SHA-256 का उपयोग करें।
- Fast hashes, unsalted hashes या custom password hashing schemes का उपयोग न करें।
- हर password hash के साथ algorithm, parameters, salt और hash version store करें, ताकि समय के साथ hashes को upgrade किया जा सके।

## Tokens, API Keys और Secrets नीति

Machine-generated tokens, API keys, recovery codes और इसी तरह के secrets के लिए:

- Secrets को cryptographically secure random number generator से generate करें।
- Raw API keys, access tokens, refresh tokens, session tokens या recovery codes को store न करें, जब तक कोई स्पष्ट operational need न हो।
- जहाँ plaintext recovery आवश्यक नहीं है, वहाँ keyed hash, hash या non-reversible verifier store करने को प्राथमिकता दें।
- Secrets को repository में commit न करें, logs में शामिल न करें, error messages में expose न करें, और test fixtures में store न करें।
- Operational secrets के लिए secrets manager, environment-specific secret storage या platform की encrypted secret facility का उपयोग करें।

## Dependency और Supply Chain Security

- Dependencies को उचित सीमा तक up to date रखें।
- Security-relevant dependency changes को release से पहले review किया जाना चाहिए।
- Cryptography, authentication, authorization, serialization, template rendering या network parsing के लिए dependencies मेंटेनर review के बिना न जोड़ें।

## Vulnerability रिपोर्ट करना

Security vulnerabilities को public issues, pull requests या discussions के माध्यम से report न करें।

यदि repository में GitHub private vulnerability reporting enabled है, तो उसी option का उपयोग करें।

यदि private vulnerability reporting उपलब्ध नहीं है, तो exploit details को public न करें। Repository या maintainer के GitHub profile में दिए गए private contact method का उपयोग करें।

Vulnerability report करते समय ये जानकारी शामिल करें:

- affected repository
- affected version, branch या commit, यदि ज्ञात हो
- issue का स्पष्ट description
- issue reproduce करने के steps
- संभावित impact
- यदि उपलब्ध हो, तो suggested mitigation

## Handling

Reports की समीक्षा good faith में की जाएगी।

मेंटेनर अतिरिक्त जानकारी मांग सकता है, fix तैयार कर सकता है, disclosure coordinate कर सकता है, या यह तय कर सकता है कि reported issue security vulnerability नहीं है।

जब तक fix या mitigation तैयार न हो जाए, issue को public disclose करने से बचें, जब तक कि maintainer असंगत रूप से लंबे समय तक जवाब न दे।
