# Changelog

## [1.29.0](https://github.com/nullplatform/tofu-modules/compare/v1.28.1...v1.29.0) (2026-02-03)


### Features

* **aws-eks:** add private access to k8s API ([7d971ad](https://github.com/nullplatform/tofu-modules/commit/7d971adae341ae920b93d0d71a01705de364be90))
* **aws-vpc:** disable public ip to EC2 ([973f1bc](https://github.com/nullplatform/tofu-modules/commit/973f1bc600fba7b2aac7450604c3b48086674fe2))
* **customers-aws-image:** update readme ([f367a8f](https://github.com/nullplatform/tofu-modules/commit/f367a8f4e6cc303958e02d76c6ff1197b05d919e))
* **nullplatform-base:** update version ([a872b6f](https://github.com/nullplatform/tofu-modules/commit/a872b6f5e3875b6988b2b432065b7ce819644555))


### Bug Fixes

* **aws-eks:** fix name varible ([2b178e1](https://github.com/nullplatform/tofu-modules/commit/2b178e11321408c165465c8b345d1acb36a26f63))
* **commitlint:** disable body-max-line-length rule ([3ed3244](https://github.com/nullplatform/tofu-modules/commit/3ed32441e387090dcc08d00fbf5532a6a1b80e9a))
* **commons-external-dns:** add switch to namespaces create ([06852f7](https://github.com/nullplatform/tofu-modules/commit/06852f7077aa8c203f5a080d8780cc6a871a43e7))
* **commons-external-dns:** add switch to namespaces create ([19cd4a6](https://github.com/nullplatform/tofu-modules/commit/19cd4a62ced0ed218ccbed07f4a29629071e02b3))
* **nullplatform-asset-ecr:** fix deprecated attribute name for region ([ed29e76](https://github.com/nullplatform/tofu-modules/commit/ed29e7687fec7799f26310e62fc118526ff75b0e))

## [1.29.0](https://github.com/nullplatform/tofu-modules/compare/v1.28.1...v1.29.0) (2026-02-03)


### Features

* **customers-aws-image:** update readme ([66532ba](https://github.com/nullplatform/tofu-modules/commit/66532ba80c1a305bf16be1970f74ea1f8df2dda9))
* **nullplatform-base:** update version ([13b459d](https://github.com/nullplatform/tofu-modules/commit/13b459df47525039f7e4637d2fa9436ffd2580f8))


### Bug Fixes

* **aws-eks:** fix name varible ([8c27b14](https://github.com/nullplatform/tofu-modules/commit/8c27b142a002ff488f83725c2e4ea1f80a7210de))
* **commons-external-dns:** add switch to namespaces create ([38bff59](https://github.com/nullplatform/tofu-modules/commit/38bff59d27fb2177f862dec10d6a061ab19bc891))
* **commons-external-dns:** add switch to namespaces create ([68de519](https://github.com/nullplatform/tofu-modules/commit/68de5196d00f7af291902ef0944ab4a649cbef27))

## [1.28.1](https://github.com/nullplatform/tofu-modules/compare/v1.28.0...v1.28.1) (2026-02-02)


### Bug Fixes

* **api_key:** rename backend.tf to providers.tf and add version constraint ([543b174](https://github.com/nullplatform/tofu-modules/commit/543b17409f56b8be9336fc67bef8f69475448d9c))

## [1.28.0](https://github.com/nullplatform/tofu-modules/compare/v1.27.0...v1.28.0) (2026-02-02)


### Features

* add pre-configured api_key modules for agent, scope and service notifications ([d5d1d76](https://github.com/nullplatform/tofu-modules/commit/d5d1d7622cab8b8905ee6ddf89a39e25a3a103b5))


### Bug Fixes

* **ci:** correct workflow reference path in tofu-test pipeline ([0c97f44](https://github.com/nullplatform/tofu-modules/commit/0c97f44f4d38198056391e89e579ca739a82e439))

## [1.27.0](https://github.com/nullplatform/tofu-modules/compare/v1.26.1...v1.27.0) (2026-01-30)


### Features

* **oci:** cloud provider ([#175](https://github.com/nullplatform/tofu-modules/issues/175)) ([bcdc2b5](https://github.com/nullplatform/tofu-modules/commit/bcdc2b55818859d660c5694a4bc20c051b9e6563))


### Bug Fixes

* **pipeline:** fix reference ([#176](https://github.com/nullplatform/tofu-modules/issues/176)) ([ac897ab](https://github.com/nullplatform/tofu-modules/commit/ac897ab2669f3f2f4535e64d378de6e0c4addce0))

## [1.26.1](https://github.com/nullplatform/tofu-modules/compare/v1.26.0...v1.26.1) (2026-01-29)


### Bug Fixes

* **base:** update outputs to use input vars instead of removed modules ([ac34128](https://github.com/nullplatform/tofu-modules/commit/ac34128a98a1758f827e00b4a4bc34a6c6b07e85))
* **gcp:** remove duplicate output and version files ([4004729](https://github.com/nullplatform/tofu-modules/commit/400472926ed4c90cbec89a29ff3ef5a032d4f081))
* **security:** align provider version constraints with repo conventions ([a47de86](https://github.com/nullplatform/tofu-modules/commit/a47de86ce69b6a2dcf699d519304c69bebea995d))

## [1.26.0](https://github.com/nullplatform/tofu-modules/compare/v1.25.0...v1.26.0) (2026-01-29)


### Features

* **azure:** unify variable names and update module conventions ([#162](https://github.com/nullplatform/tofu-modules/issues/162)) ([d8bccf1](https://github.com/nullplatform/tofu-modules/commit/d8bccf17878008538978d2127e678364f988ff34))
* **base:** security and nrn tags ([#160](https://github.com/nullplatform/tofu-modules/issues/160)) ([2ad4b2f](https://github.com/nullplatform/tofu-modules/commit/2ad4b2f9227b89032d5a2259a513a3a75a14014f))

## [1.25.0](https://github.com/nullplatform/tofu-modules/compare/v1.24.3...v1.25.0) (2026-01-29)


### Features

* **613:** add support cert manager for oci ([#152](https://github.com/nullplatform/tofu-modules/issues/152)) ([1282171](https://github.com/nullplatform/tofu-modules/commit/12821712e781ae1b976feeafa6f29b4be0abb4c4))

## [1.24.3](https://github.com/nullplatform/tofu-modules/compare/v1.24.2...v1.24.3) (2026-01-28)


### Bug Fixes

* **eks:** resolve Auto Mode compatibility issues ([#167](https://github.com/nullplatform/tofu-modules/issues/167)) ([c58baea](https://github.com/nullplatform/tofu-modules/commit/c58baea3611b3e3c9e847e7b742f1975372eae69))

## [1.24.2](https://github.com/nullplatform/tofu-modules/compare/v1.24.1...v1.24.2) (2026-01-28)


### Bug Fixes

* api key lifecycle ([#165](https://github.com/nullplatform/tofu-modules/issues/165)) ([86fd93e](https://github.com/nullplatform/tofu-modules/commit/86fd93e8be4569b41b43b791585260f3168425c7))

## [1.24.1](https://github.com/nullplatform/tofu-modules/compare/v1.24.0...v1.24.1) (2026-01-27)


### Bug Fixes

* api key lifecycle ([#163](https://github.com/nullplatform/tofu-modules/issues/163)) ([beaa60f](https://github.com/nullplatform/tofu-modules/commit/beaa60fdcc527122acac669f78a8ccf10a687042))
* **api_key:** add create_before_destroy to prevent service disruption ([7efc3ed](https://github.com/nullplatform/tofu-modules/commit/7efc3edb82945e50d39734eb1a1b0de6b29d58fc))
* replace agent helm release when API key rotates ([b0ea1c9](https://github.com/nullplatform/tofu-modules/commit/b0ea1c903477d25ba46cc656a85c0245511d2d4f))
* replace notification channels when API key rotates ([07d3e17](https://github.com/nullplatform/tofu-modules/commit/07d3e17f29087c64028aad6b61dfc37cb1443e32))

## [1.24.0](https://github.com/nullplatform/tofu-modules/compare/v1.23.0...v1.24.0) (2026-01-26)


### Features

* introduce api_key module for unified API key management  ([#155](https://github.com/nullplatform/tofu-modules/issues/155)) ([aded8a6](https://github.com/nullplatform/tofu-modules/commit/aded8a6b048590d2427f8072e419edd91af83064))

## [1.23.0](https://github.com/nullplatform/tofu-modules/compare/v1.22.1...v1.23.0) (2026-01-26)


### Features

* add action of release ([cbee19a](https://github.com/nullplatform/tofu-modules/commit/cbee19a5409a914f6468313f650b0b797f29d82e))
* add action of release ([8f695ed](https://github.com/nullplatform/tofu-modules/commit/8f695edf0805a35fbc430c23db60fbadce2da3ec))
* add action of release ([9421b67](https://github.com/nullplatform/tofu-modules/commit/9421b678a8b627b414de068d8ab6a466e4b13a12))
* add agent, scope and scope association ([f508cca](https://github.com/nullplatform/tofu-modules/commit/f508ccaf263835b7fc53263bbce4d142976d1cb4))
* add agnostic agent ([1d1d5e3](https://github.com/nullplatform/tofu-modules/commit/1d1d5e35720864e035f3995237365392b453f83e))
* add aks module ([ef313d9](https://github.com/nullplatform/tofu-modules/commit/ef313d9077f3d69e207fcff5d3f4aabd64b539d0))
* add data tenent id ([993dd15](https://github.com/nullplatform/tofu-modules/commit/993dd15bfd9320f753bf26fd43d5da972bec6331))
* add image_tag var ([87b8758](https://github.com/nullplatform/tofu-modules/commit/87b87588e38433f5cec4888e76303441fc36258d))
* add output vnet ([d20b871](https://github.com/nullplatform/tofu-modules/commit/d20b871bc710eee36700b2a1e3784384820f1a9e))
* add scope definion agent association ([416526d](https://github.com/nullplatform/tofu-modules/commit/416526d72150a2a1adba90263c1d67955e623ce3))
* add scope definition modules ([eba0ba3](https://github.com/nullplatform/tofu-modules/commit/eba0ba36e80fdd8245523e78fc376e24930039f3))
* add sku input ([01450ac](https://github.com/nullplatform/tofu-modules/commit/01450ac176e4f0f96621038e5f7158ed5b6dc5f2))
* add sku input ([78107a9](https://github.com/nullplatform/tofu-modules/commit/78107a9b62188bc4bda3cc1fe29f4c26de114b40))
* add sku input ([faa4700](https://github.com/nullplatform/tofu-modules/commit/faa470032de8b8b8ba7b9b4ee47c79ef0229b558))
* add support for aro ingress controller ([6fe2813](https://github.com/nullplatform/tofu-modules/commit/6fe2813070cd1a91f3e5221497bcbada4a390868))
* add support to prometheus operator ([5e85aa1](https://github.com/nullplatform/tofu-modules/commit/5e85aa1bc1c49c926d1747ddd670d046b4d7e5d6))
* add validatation cloud provider ([f1880ad](https://github.com/nullplatform/tofu-modules/commit/f1880ad1d05199dd7e19d37eef5468e5c2148e14))
* **aent:** add init_scripts ([4b91906](https://github.com/nullplatform/tofu-modules/commit/4b919060f52551a775fa4681c4e0a138be7b59a4))
* **aent:** add init_scripts ([e806f3f](https://github.com/nullplatform/tofu-modules/commit/e806f3fa026a26659d70a3ecbd9940b215e4527b))
* **aent:** delete unknow args ([8f3bffc](https://github.com/nullplatform/tofu-modules/commit/8f3bffc2e393049095c480747b20ff41c41e3f91))
* **agent:** add azure config to agent ([c27d6a5](https://github.com/nullplatform/tofu-modules/commit/c27d6a5c8c506296a114268070191e558f69fa1c))
* **agent:** add azure to agent ([0bde56c](https://github.com/nullplatform/tofu-modules/commit/0bde56cf16e18934d419d8185ef40007fc4cad61))
* **agent:** add config external-dns to aws config ([3d69436](https://github.com/nullplatform/tofu-modules/commit/3d694365764e92a23a0c1f2c2a076c644801d2d0))
* **agent:** add config external-dns to aws config ([#105](https://github.com/nullplatform/tofu-modules/issues/105)) ([1a828f9](https://github.com/nullplatform/tofu-modules/commit/1a828f97f671ea4dfcdf34bb49ee7e21ec5dac43))
* **agent:** add config for azure ([23da9fd](https://github.com/nullplatform/tofu-modules/commit/23da9fdb8aaa136781d7841c935f5dbb6f2f2577))
* **agent:** add multi cloud ([adbaa97](https://github.com/nullplatform/tofu-modules/commit/adbaa976964f8531cdf372985378e82ff225375a))
* **agent:** fix cert-manager name templates ([a3913db](https://github.com/nullplatform/tofu-modules/commit/a3913dbe5e2737e724a1c7c561c33ab4dd558a8c))
* **agent:** fix image tag variable ([667da65](https://github.com/nullplatform/tofu-modules/commit/667da65400dc18b5758679dd724c0de6b3586ab5))
* **agent:** fix readme ([96faf72](https://github.com/nullplatform/tofu-modules/commit/96faf7202f3d61b276a80744db80f538f4fa2369))
* **agent:** fix template default ([dc225b5](https://github.com/nullplatform/tofu-modules/commit/dc225b5a1c16a7f6fc1e29537ad4dc74df76dca1))
* **agent:** fix template default ([9ac324c](https://github.com/nullplatform/tofu-modules/commit/9ac324c114baa4be482d06779f067b9c10dff051))
* **agent:** move identical variables to global configuration ([2b78254](https://github.com/nullplatform/tofu-modules/commit/2b78254ab4d16251ac3d1c4504189b5ce3201841))
* **agent:** move image-tag variable ([f9ac77b](https://github.com/nullplatform/tofu-modules/commit/f9ac77b09422040b97b25609032afc56373b572d))
* **agent:** move image-tag variable ([8c0c483](https://github.com/nullplatform/tofu-modules/commit/8c0c483592acd44ada02c81ea4346f2716c8696f))
* **agent:** reactor cert-manager ([36026dd](https://github.com/nullplatform/tofu-modules/commit/36026ddf51b2859de480a9882a9caffa6ada6bda))
* **agent:** tofu fmt ([e5aa787](https://github.com/nullplatform/tofu-modules/commit/e5aa787583afb204ce32e4b22873bcfa1297d997))
* aks acr integration ([#120](https://github.com/nullplatform/tofu-modules/issues/120)) ([e2237b6](https://github.com/nullplatform/tofu-modules/commit/e2237b608ee9ccfabb40582582ab0e664640e13a))
* aks module release ([51ff70d](https://github.com/nullplatform/tofu-modules/commit/51ff70d0c557dcd6a9f3001d4186564a6ea3d545))
* **aro:** added google and cloudflare ns for txt record validation ([6714185](https://github.com/nullplatform/tofu-modules/commit/67141853de441661f6a025d6ced308364334afd7))
* **auth:** add output authorization module ([b3f616c](https://github.com/nullplatform/tofu-modules/commit/b3f616c086f4994546ed9526a319910e6f305f28))
* **aws-iam:** add aws iam module ([8f53196](https://github.com/nullplatform/tofu-modules/commit/8f53196411950664824cd1a4baece7fa8c986df4))
* **aws-iam:** add aws iam module ([f728ef3](https://github.com/nullplatform/tofu-modules/commit/f728ef3aed084baffb5e639768041a821601b52a))
* **aws-iam:** add output to rol arn ([ac7676d](https://github.com/nullplatform/tofu-modules/commit/ac7676d9ce5f652ed3c9b46450bcae2149fffcc8))
* **aws:** fix cloud aws domain_name ([60eabd3](https://github.com/nullplatform/tofu-modules/commit/60eabd39746c762b63709af2e825b0c92e1ea43f))
* **azure:** Add private DNS zone module ([813cad3](https://github.com/nullplatform/tofu-modules/commit/813cad3709d212cc3d78bab5000261f8afec2aa4))
* **azure:** Add private DNS zone module ([#90](https://github.com/nullplatform/tofu-modules/issues/90)) ([5d4399e](https://github.com/nullplatform/tofu-modules/commit/5d4399ea5f1823cc5d96c1075083b74d426b4ff1))
* **cert manager:** add support namespace name for cert manager ([d44f7c7](https://github.com/nullplatform/tofu-modules/commit/d44f7c76e56021c7a1153b15058e984062b2c3fd))
* **cert-manager:** add aws support ([858e346](https://github.com/nullplatform/tofu-modules/commit/858e3464fa74de5f64e67fcfe60bf5c6199cb177))
* **cert-manager:** fix version helm cert manage ([79796a8](https://github.com/nullplatform/tofu-modules/commit/79796a897ac3ea82da053a8c3aeaf888a751e7a6))
* **cert-manager:** normalize naming to helm ([b8e9e7b](https://github.com/nullplatform/tofu-modules/commit/b8e9e7b3fbebc5d3a18f078aa5a6162f3ba46758))
* **cert-manager:** separate providier ([9e8bc7b](https://github.com/nullplatform/tofu-modules/commit/9e8bc7b9f5d1b2833bc2e5ea6ae6e652b5316f2b))
* **cert-manager:** separate providier ([0888dbe](https://github.com/nullplatform/tofu-modules/commit/0888dbe387d95f575d413e209b46d2729c440330))
* **cert-manager:** separate providier ([cd7e81e](https://github.com/nullplatform/tofu-modules/commit/cd7e81e19e4af189de60e8f6616a98b89afbf743))
* **cert-manager:** separate providier ([f39fa84](https://github.com/nullplatform/tofu-modules/commit/f39fa84282b43c90fd87d9f92c3521e34b21e5ec))
* **cert-manager:** separate providier ([a2dfadb](https://github.com/nullplatform/tofu-modules/commit/a2dfadbdeacde84783ea9cbd0d1563fbaae6c1ba))
* **cert-manager:** separate providier ([882933b](https://github.com/nullplatform/tofu-modules/commit/882933b73b6dd60cc83396611d7b79fce8bd1e01))
* **cert-manager:** separate providier ([3bd79db](https://github.com/nullplatform/tofu-modules/commit/3bd79dbd7361014d475da29812972a057ecce508))
* **cert-manager:** separate providier ([b51fec9](https://github.com/nullplatform/tofu-modules/commit/b51fec9cf71f0d628de177ead342b86765b422f7))
* **cert-manager:** update varsion cert manager ([46b388e](https://github.com/nullplatform/tofu-modules/commit/46b388e4b0f891bdbbc5e97c3445afb225175d71))
* **chart:** new version of charts ([#122](https://github.com/nullplatform/tofu-modules/issues/122)) ([83a8b39](https://github.com/nullplatform/tofu-modules/commit/83a8b399b836ca053fe8fc7b8689d1c198cd4e32))
* edit acr georeplication ([1448c56](https://github.com/nullplatform/tofu-modules/commit/1448c567d3fa4a4472fdba7eb5e9226fe280a72c))
* edit count of nodes ([bd46b4c](https://github.com/nullplatform/tofu-modules/commit/bd46b4ce4b069e994d67dbe9b00fcd984a51d846))
* edit node agents_pool_max_surge ([bca13bd](https://github.com/nullplatform/tofu-modules/commit/bca13bdc5fd9d76375dbb915c907b0ea61cee54a))
* edit node agents_pool_max_surge ([3a5bec1](https://github.com/nullplatform/tofu-modules/commit/3a5bec153844bfc1f20e462a589c03f255316eab))
* edit provider aks ([c6817f2](https://github.com/nullplatform/tofu-modules/commit/c6817f21bbc0c67273468c9bad2b0ef177142b8c))
* edit readme ([#63](https://github.com/nullplatform/tofu-modules/issues/63)) ([12cb339](https://github.com/nullplatform/tofu-modules/commit/12cb339e7bf54de460251abb328da95de54e5d39))
* edit var ([b4e869f](https://github.com/nullplatform/tofu-modules/commit/b4e869f9f87b92e835a4316446c471c8262f5669))
* edit var ([57da603](https://github.com/nullplatform/tofu-modules/commit/57da603063c845fdac5db2cf4f06adc75381b9c1))
* edit variables ([44c9674](https://github.com/nullplatform/tofu-modules/commit/44c967493a9c98dcd2c03bb8d6a9b74d5d6d9460))
* edit variables ([60f47ed](https://github.com/nullplatform/tofu-modules/commit/60f47edcfdb5e45738e8928ce87ff2e6bbfc2861))
* edit variables ([cc370e5](https://github.com/nullplatform/tofu-modules/commit/cc370e5a8d18cfbe0a77c4ea804449a684c747dc))
* edit variables ([3002fcc](https://github.com/nullplatform/tofu-modules/commit/3002fccdfdb33a90657d74b469d7664c423a15b5))
* edit variables ([99cf67a](https://github.com/nullplatform/tofu-modules/commit/99cf67a6236e279537eabfbfda884c7146a9187e))
* **esternal-dns:** resolve conflicts ([4f71b63](https://github.com/nullplatform/tofu-modules/commit/4f71b6359456c3c4e201deec7aed30c6b72092bd))
* **external-dns:** add config to aws ([0b492b8](https://github.com/nullplatform/tofu-modules/commit/0b492b8f5d84e170fff52a856e63bd199bc7d7ee))
* **external-dns:** add validation to variables ([c4c3e36](https://github.com/nullplatform/tofu-modules/commit/c4c3e364923802d118ab7557ce545f356bb59275))
* **external-dns:** add validation to variables ([d091739](https://github.com/nullplatform/tofu-modules/commit/d0917390351562ac3449e4f562661295f3ce58fc))
* **external-dns:** delete google provider ([94cf414](https://github.com/nullplatform/tofu-modules/commit/94cf41421a233876cbc133e2ff855dee39c0520f))
* **external-dns:** fix init script ([a2c35fd](https://github.com/nullplatform/tofu-modules/commit/a2c35fd598cc57e212cf6e9b18e52ad6d5387224))
* **externaldns:** support multi external dns ([#97](https://github.com/nullplatform/tofu-modules/issues/97)) ([3ddbd8e](https://github.com/nullplatform/tofu-modules/commit/3ddbd8ebf152722be693539493229a6f6098a27c))
* false redundacy ([199d908](https://github.com/nullplatform/tofu-modules/commit/199d908e8bc7bdaf40ecceb3e28f539a124c892a))
* false redundacy ([8c5b585](https://github.com/nullplatform/tofu-modules/commit/8c5b5855fba5826d3052523fa1534907dbf09fbe))
* false redundacy ([7040143](https://github.com/nullplatform/tofu-modules/commit/7040143f3b0519ec4b70b325d403f75e10821f82))
* I'm adding support for Prometheus Operator ([f1c6e08](https://github.com/nullplatform/tofu-modules/commit/f1c6e080b1be49f575e625202c72a6aa03011ea9))
* I'm adding support for Prometheus Operator ([9e1db19](https://github.com/nullplatform/tofu-modules/commit/9e1db198732650b24e06e76592765c647b0d35b5))
* I'm adding support for Prometheus Operator ([11557ea](https://github.com/nullplatform/tofu-modules/commit/11557eabc0950e07b216e7c4eb7fb78a8b48dd8c))
* **infra:** add v1 to namespace external dns ([ae35596](https://github.com/nullplatform/tofu-modules/commit/ae3559643f72bd3f8f188dfc215e449fae70d813))
* **main:** add PR to execute linter& docs ([81ebff6](https://github.com/nullplatform/tofu-modules/commit/81ebff67c08200b31b55ba6974d31f4b6a245b57))
* **main:** rollback ([1681548](https://github.com/nullplatform/tofu-modules/commit/16815482cd040b4e4ba4259b4342c7bafb3be98a))
* **oci:** add support for oci ([#146](https://github.com/nullplatform/tofu-modules/issues/146)) ([ffaa72d](https://github.com/nullplatform/tofu-modules/commit/ffaa72d6d529ef168a422b7a4242a80a56920104))
* oid enabled ([0f48c61](https://github.com/nullplatform/tofu-modules/commit/0f48c61374a18d62c99b5c5c1ed332d2da490fd2))
* pipeline ([25c0a28](https://github.com/nullplatform/tofu-modules/commit/25c0a288cdfe4384d888935159ce7d1de126706b))
* **pre-commit:** add conventional commits validation ([8612274](https://github.com/nullplatform/tofu-modules/commit/8612274595c33c6e14f8d55b33b38c907503962d))
* **promnetheus:** edit variables ([#56](https://github.com/nullplatform/tofu-modules/issues/56)) ([45ddc88](https://github.com/nullplatform/tofu-modules/commit/45ddc880afc48a4f93de6f132603ad3a4e73dfb1))
* **provider:** add support for azure devops ([#133](https://github.com/nullplatform/tofu-modules/issues/133)) ([e0125d9](https://github.com/nullplatform/tofu-modules/commit/e0125d921a288f866623661caf30d95be592e77d))
* **release:** edit yaml release ([#58](https://github.com/nullplatform/tofu-modules/issues/58)) ([b50b97e](https://github.com/nullplatform/tofu-modules/commit/b50b97ed0212e6cded7596ed5c91d2f7d75ea218))
* **scope definition:** edit lifecycle ([96d482a](https://github.com/nullplatform/tofu-modules/commit/96d482a1ac1e3c75598ed43c65835add866b23d5))
* **scope-definition-agent:** fix data http templates ([f89a4ef](https://github.com/nullplatform/tofu-modules/commit/f89a4ef56d5c281b8f3a2e993f1c14fbf3b59a4c))
* **scope-definition:** fix agent telemetry config ([#50](https://github.com/nullplatform/tofu-modules/issues/50)) ([cd59a81](https://github.com/nullplatform/tofu-modules/commit/cd59a81e4479d8761be1f4988e7d137dd7f126bf))
* **scope:** parameterize repository values ([#110](https://github.com/nullplatform/tofu-modules/issues/110)) ([297c1a3](https://github.com/nullplatform/tofu-modules/commit/297c1a3ed788faf13cc9ef76c9480ad2227db9dc))
* service definition and service association channel ([#121](https://github.com/nullplatform/tofu-modules/issues/121)) ([44e6a8e](https://github.com/nullplatform/tofu-modules/commit/44e6a8e35bf3ed9cf42b0cd090eae215e62ff71a))
* **tofu:** apply tofu fmt ([d2c4f80](https://github.com/nullplatform/tofu-modules/commit/d2c4f80a82d4e442ed5a7bdecdf94704e2447d3b))
* **tofu:** resolve conflicts ([61692e3](https://github.com/nullplatform/tofu-modules/commit/61692e3ec78365d96f9cec2eae419768731cf12b))
* **tofu:** run fmt ([371342b](https://github.com/nullplatform/tofu-modules/commit/371342bf77151e4f5c70e4e3a3a27c605af16454))


### Bug Fixes

* **acm:** fix logic ([cafffea](https://github.com/nullplatform/tofu-modules/commit/cafffea8c62d26716da2ad70564ccffc01c2f428))
* add disclaimer for registration_enabled usage ([ac1fd0a](https://github.com/nullplatform/tofu-modules/commit/ac1fd0a60b373656a922e5836a8f38fb5986e807))
* add validation for virtual_network_links ([76438d0](https://github.com/nullplatform/tofu-modules/commit/76438d08e1160f3d18e292f5bfa2c35ac7a3283e))
* added AZ private DNS variables ([8b2b714](https://github.com/nullplatform/tofu-modules/commit/8b2b7144d4a57f5a1ffaa5dbba3c851f769a92f9))
* **agent:** add extra-config variable ([1ef4815](https://github.com/nullplatform/tofu-modules/commit/1ef4815aff0c4a6ee10759de2ff4262e2955cfac))
* **agent:** add permission to verifiedpermissions ([7d2c50c](https://github.com/nullplatform/tofu-modules/commit/7d2c50cbf2afcbd16724723e3cb12e235af7ea11))
* **agent:** add permission to verifiedpermissions ([#145](https://github.com/nullplatform/tofu-modules/issues/145)) ([369012e](https://github.com/nullplatform/tofu-modules/commit/369012e79199a5f70d696a5f2dc082ed76d208b4))
* **agent:** fix repos extra variable ([dbda999](https://github.com/nullplatform/tofu-modules/commit/dbda999d04e6c5d2657653925f13b22ed952ec79))
* **agent:** fix values tmpl ([b1044bc](https://github.com/nullplatform/tofu-modules/commit/b1044bc4ce0ecb89c931cf12ef7520e55ca5633a))
* **agent:** fix values tmpl ([26721ab](https://github.com/nullplatform/tofu-modules/commit/26721ab656ec068f52b3d9945c1a15ab0c1acf4a))
* **agent:** fix values tmpl ([3640da2](https://github.com/nullplatform/tofu-modules/commit/3640da2316ed55630cda4b3f2700ba91bae0db0f))
* **agent:** fix var repo extra ([bf989fa](https://github.com/nullplatform/tofu-modules/commit/bf989faa6817e7c25407c93543a44a81633b8288))
* **agent:** refactor values agent ([46023a8](https://github.com/nullplatform/tofu-modules/commit/46023a8b68174e547695d7c3678d15b41fefffb3))
* **agent:** upgrade helm chart version ([596e05f](https://github.com/nullplatform/tofu-modules/commit/596e05f961ecd32fa8f00796f5f4cf4592cfd43b))
* **aks:** add network contributor ([0305ade](https://github.com/nullplatform/tofu-modules/commit/0305ade8dda6389a57e47cb4999abeb9e2362f5c))
* **aks:** add network contributor ([#114](https://github.com/nullplatform/tofu-modules/issues/114)) ([1542270](https://github.com/nullplatform/tofu-modules/commit/1542270b0f8a34ff52918bbdcbca42a75936f5e8))
* **alb-controller:** add perdiod sync variable ([f96191b](https://github.com/nullplatform/tofu-modules/commit/f96191bc4b7c4c7b1d15a55924dbc2128f2620a5))
* **alb-controller:** add policy to alb controller ([63596f3](https://github.com/nullplatform/tofu-modules/commit/63596f30cf3da80fbdf2a07b22dfaa3411c02d82))
* **alb-controller:** fix sa to v1 ([ab6f557](https://github.com/nullplatform/tofu-modules/commit/ab6f5574e047112dd5b5ea4a6067e6cd99f58c5f))
* **alb-controller:** fix sa to v1 ([8a9d1d3](https://github.com/nullplatform/tofu-modules/commit/8a9d1d3b083041d53fa3001c1ab51f549459fe4a))
* **asset:** fix naming policies ([743e5ba](https://github.com/nullplatform/tofu-modules/commit/743e5ba5ea99b7fe5938b6a9a412d92cd8d840d4))
* **asset:** fix naming policies ([6ecff04](https://github.com/nullplatform/tofu-modules/commit/6ecff04b4825a93bb2b9e83d53c8e41e07f9691c))
* **aws-region:** use .name instead of .region attribute in aws_region data source ([0d0912e](https://github.com/nullplatform/tofu-modules/commit/0d0912eab1a91b3d22cdf6e6f6b5116a1872c839))
* **aws-region:** use .name instead of .region attribute in aws_region data source ([#154](https://github.com/nullplatform/tofu-modules/issues/154)) ([7094878](https://github.com/nullplatform/tofu-modules/commit/7094878a5eabcd8838c9e2be967450e0028cb415))
* **azure-aks:** add role to vnet ([b40d33d](https://github.com/nullplatform/tofu-modules/commit/b40d33d4f80cbed3c552a5b4f7ac593c145ff5f3))
* **azure-aks:** principal_id variable ([6e3d54c](https://github.com/nullplatform/tofu-modules/commit/6e3d54c4bc00833161a03d4c65d0b9db8aba9b9f))
* **azure-aks:** principal_id variable ([6232bf0](https://github.com/nullplatform/tofu-modules/commit/6232bf0f44c7c99377b220f28895bd7a52039b35))
* **base-gateways:** add annottaion to LB use subnet private ([8e3b09e](https://github.com/nullplatform/tofu-modules/commit/8e3b09e0a57f0a86e0494145b69d8da0540123d7))
* **base-iam:** fix naming policies to multiple cluster ([c1d5701](https://github.com/nullplatform/tofu-modules/commit/c1d5701301797eb163c2cdbb05d194ba84201c85))
* **base:** adding gateway name parameter ([#139](https://github.com/nullplatform/tofu-modules/issues/139)) ([a47a299](https://github.com/nullplatform/tofu-modules/commit/a47a299a890570a2960b90195247de9b45d0921a))
* **base:** disabled webhook option ([2496ba4](https://github.com/nullplatform/tofu-modules/commit/2496ba4bd091f7bc8f6f2e19de18a2ff003ceee8))
* **base:** fix naming k8s-provider ([d89fe19](https://github.com/nullplatform/tofu-modules/commit/d89fe1942e4f6127718d8430d98674fd9da044f3))
* **base:** remove provider nullplarform ([#69](https://github.com/nullplatform/tofu-modules/issues/69)) ([bb376e9](https://github.com/nullplatform/tofu-modules/commit/bb376e9aa0128f5e3f485294700a212380e219eb))
* **base:** update version chart ([0bc1fbd](https://github.com/nullplatform/tofu-modules/commit/0bc1fbdd45ae873a42c13c7a8618bd5f54f140ca))
* **base:** update version chart ([#116](https://github.com/nullplatform/tofu-modules/issues/116)) ([26a1034](https://github.com/nullplatform/tofu-modules/commit/26a1034eec4285cb3fca8f8904c0a4d2da76524f))
* **base:** update version heml chart ([b8bec08](https://github.com/nullplatform/tofu-modules/commit/b8bec0826d820583f5cbbb2e1b065554e967fa15))
* **base:** upgrade version helm ([87c1aae](https://github.com/nullplatform/tofu-modules/commit/87c1aae7e7235a75f3572cad276db1c00a14aa52))
* **cert manager:** fix linter ([#95](https://github.com/nullplatform/tofu-modules/issues/95)) ([260d4c2](https://github.com/nullplatform/tofu-modules/commit/260d4c246c25f924fe49ead3801562cf188b25f4))
* **cert-manager-iam:** fix allow hosted zone ([e819f79](https://github.com/nullplatform/tofu-modules/commit/e819f79b97656a75832242d2f6be13218583baff))
* **cert-manager-iam:** fix sa name & add private zone managed ([5142697](https://github.com/nullplatform/tofu-modules/commit/51426976d172439c55700e8df560027e10be904a))
* **cert-manager:** add helm options ([7bd7b2c](https://github.com/nullplatform/tofu-modules/commit/7bd7b2cbd36dba868805f11cabaaab7966bc1d5a))
* **cert-manager:** fix namespace error and improve configuration ([7d2e296](https://github.com/nullplatform/tofu-modules/commit/7d2e29617574f887b758dd2bfc2f6d1a91a29669))
* **cert-manager:** fix namespace error and improve configuration ([4af6c98](https://github.com/nullplatform/tofu-modules/commit/4af6c98918e309b94e5e03a499316c473ed37821))
* **cert-manager:** remove deafult to mandatory variables ([351a7f9](https://github.com/nullplatform/tofu-modules/commit/351a7f98c1de121640bd9b8a29bcb8b09069114d))
* **cert-manager:** remove IRSA ([6383227](https://github.com/nullplatform/tofu-modules/commit/63832273477c7bb8220633444d28158e8554b929))
* **cert-manager:** resolve conflicts ([c6a3cb7](https://github.com/nullplatform/tofu-modules/commit/c6a3cb7e2a864038fed59334302ca2803cffb2a5))
* **chart-base:** add istio gateway security groups ([#143](https://github.com/nullplatform/tofu-modules/issues/143)) ([03fa7be](https://github.com/nullplatform/tofu-modules/commit/03fa7be2d3c9970b41935e683b5b58df71de27a1))
* commons changes readme ([ee79884](https://github.com/nullplatform/tofu-modules/commit/ee79884f8db1336642e4f8d53c3f93582b72df92))
* commons changes readme ([3207ce2](https://github.com/nullplatform/tofu-modules/commit/3207ce234f7f0e20f02748ab7026a6b1841bdb7a))
* correct typo in private_dns_resource_group_name description ([d528e53](https://github.com/nullplatform/tofu-modules/commit/d528e530763c023610302b3501a58e5d5867540c))
* correct YAML indentation in agent template ([0503606](https://github.com/nullplatform/tofu-modules/commit/0503606d322f87dacca8c8d32789c3c900397a43))
* **eks:** add aditional security gorup ([2c44375](https://github.com/nullplatform/tofu-modules/commit/2c44375a379383bc9a2f22a49eeb4086277e20e9))
* **eks:** disable node security group to avoid ALB controller conflict ([#137](https://github.com/nullplatform/tofu-modules/issues/137)) ([8cbe80b](https://github.com/nullplatform/tofu-modules/commit/8cbe80b63d8edf2763d8bb1ed88e3b9b1b64a111))
* **eks:** segretate logic of node groups ([0937b93](https://github.com/nullplatform/tofu-modules/commit/0937b93cc9c6e523c21c189d1c888ff80db384d0))
* external-dns secret and namespace depends ([fc4da0b](https://github.com/nullplatform/tofu-modules/commit/fc4da0b084006efa2964d2e35ee9d306aa1d74ce))
* external-dns secret and namespace depends ([4ee0bbd](https://github.com/nullplatform/tofu-modules/commit/4ee0bbd3b56872b85b9589c177d1e26e868506eb))
* **external-dns-iam:** add trust policy ([4fc890f](https://github.com/nullplatform/tofu-modules/commit/4fc890f92d15a9e7fdbf00b9bc3cbb4a9b447f3a))
* **external-dns:** add action external dns policy ([4752701](https://github.com/nullplatform/tofu-modules/commit/4752701633dbbcf4242134001342310161a75a89))
* **external-dns:** add manage private zone ([e0fbfff](https://github.com/nullplatform/tofu-modules/commit/e0fbfff1b83c442a652aa228f89485ff513a8f24))
* **external-dns:** add rbac  ([#141](https://github.com/nullplatform/tofu-modules/issues/141)) ([ea5c5bb](https://github.com/nullplatform/tofu-modules/commit/ea5c5bbedb559b5d797185186204353a6d65186a))
* **external-dns:** add rbac to manage dns endpoints ([546876e](https://github.com/nullplatform/tofu-modules/commit/546876e59e2706d36c10c37c832f47bf3b377ee6))
* **external-dns:** add source httproute ([ba3b6fc](https://github.com/nullplatform/tofu-modules/commit/ba3b6fc3ea16925e92ebd14059b549e39d0672a4))
* **external-dns:** add source variable ([aed8c25](https://github.com/nullplatform/tofu-modules/commit/aed8c25fe5054b8e4f842dd24c264ed535f6a42e))
* **external-dns:** change policy to variable ([#73](https://github.com/nullplatform/tofu-modules/issues/73)) ([739ae02](https://github.com/nullplatform/tofu-modules/commit/739ae02d4d8cab9bf37a1b4e020fcde62c9df18c))
* **external-dns:** delete namespace manifest ([17b7495](https://github.com/nullplatform/tofu-modules/commit/17b7495fb1808c3aa740299bb9e22fd5a3297ba9))
* **external-dns:** fix external dns varaible type ([d44879c](https://github.com/nullplatform/tofu-modules/commit/d44879ceeae517c5dec097c7fa6d19e9b8bea06c))
* **external-dns:** fix external dns varaible type ([#128](https://github.com/nullplatform/tofu-modules/issues/128)) ([af26c59](https://github.com/nullplatform/tofu-modules/commit/af26c590b04089a7202d07a09ac6e6a30feaa06c))
* **external-dns:** fix gsa_email variable ([d0e20fe](https://github.com/nullplatform/tofu-modules/commit/d0e20fec9c8bd60a57431009b9d3f6993f37c8af))
* **external-dns:** fix name chart ([b0c4d05](https://github.com/nullplatform/tofu-modules/commit/b0c4d0595f5b4a3971a6187820a0be667cc0b042))
* **external-dns:** fix name chart ([01852d9](https://github.com/nullplatform/tofu-modules/commit/01852d9b10e0a72be589566ea43720531827b21a))
* **external-dns:** fix rbac to dnsendpoint ([1e26890](https://github.com/nullplatform/tofu-modules/commit/1e268909545969d3d41005bd40d701d1cd8b7906))
* **external-dns:** fix sources ([fe50c75](https://github.com/nullplatform/tofu-modules/commit/fe50c75187b5b60c2e7f4286adc651a3186f3e88))
* **external-dns:** move zone_type to variable ([bd3ac1b](https://github.com/nullplatform/tofu-modules/commit/bd3ac1baa98cd08a693aaeaafed53a51a19330a3))
* **external-dns:** remove regsitry ([73cf983](https://github.com/nullplatform/tofu-modules/commit/73cf983930e0dbbccc37cc94ddacaff5be0bae03))
* **external-dns:** resolve conflicts ([4c9a701](https://github.com/nullplatform/tofu-modules/commit/4c9a7015daeb1664a7c33f883686955b6416bc62))
* **external-dns:** rollback name dns provider ([16ecdd9](https://github.com/nullplatform/tofu-modules/commit/16ecdd9f98c38b8b74724edf51d7d0375eb14819))
* **external-dns:** sa name ([e0bdcb6](https://github.com/nullplatform/tofu-modules/commit/e0bdcb693ee5bf62706b0212bdec136e91ba2ba7))
* **external-dns:** set default value ([#126](https://github.com/nullplatform/tofu-modules/issues/126)) ([c652f64](https://github.com/nullplatform/tofu-modules/commit/c652f64adc2e04683c6495a2eaae8dd4a810e950))
* **external-dns:** single managed hosted zone ([8dd9c20](https://github.com/nullplatform/tofu-modules/commit/8dd9c20caba37fc513d53e77a8c3e05d0bc26f18))
* **gke:** add protection destroy as false ([#102](https://github.com/nullplatform/tofu-modules/issues/102)) ([26f0788](https://github.com/nullplatform/tofu-modules/commit/26f07883fd2bf6d0f351755d0e730fecc281e49a))
* **helm:** add options to applies ([987403a](https://github.com/nullplatform/tofu-modules/commit/987403a9269659bfa8d008d9f80735675283f678))
* **helm:** add options to applies ([b64a340](https://github.com/nullplatform/tofu-modules/commit/b64a3406d23b79b8ea8388917d8661c8d214ac80))
* **iam-cert-manager:** arn role ([f9e27bd](https://github.com/nullplatform/tofu-modules/commit/f9e27bd092427636ef4e09e6ab3460bda61d2320))
* **iam-cert-manager:** arn role ([e0e112c](https://github.com/nullplatform/tofu-modules/commit/e0e112c45c48f89686cf09914a624541f2c45d43))
* **iam-cert-manager:** arn role ([65c5fb0](https://github.com/nullplatform/tofu-modules/commit/65c5fb0196413b06582cedf9df5c96f7e559049a))
* **iam-cert-manager:** arn role ([4ea5275](https://github.com/nullplatform/tofu-modules/commit/4ea52750bd23f08da11f5d9a744bafa7c5b22b33))
* **iam-cert-manager:** arn role ([63959ac](https://github.com/nullplatform/tofu-modules/commit/63959ac25ac14fe7134ec7bd1439caf1b728af63))
* **infra:** fix namespace name ([5f22a63](https://github.com/nullplatform/tofu-modules/commit/5f22a63e1a08099399feb9c67d093b62fe513b08))
* **istio:** wait for condition ([8cbe4e1](https://github.com/nullplatform/tofu-modules/commit/8cbe4e1f3452ebf9c382613b489e613dc941a1a3))
* make virtual_network_links required without default ([329f5a5](https://github.com/nullplatform/tofu-modules/commit/329f5a5a3c44d97239eb6875aa6784881a603e41))
* **null-code_reposotory:** update readme.md ([c478123](https://github.com/nullplatform/tofu-modules/commit/c4781236edf44c89c9947963a5ff685ea187637d))
* **nullplatform-base:** add security groups to gateways ([2b72d60](https://github.com/nullplatform/tofu-modules/commit/2b72d6023cd78242c773d8dbb2a1668963db07b9))
* **nullplatform:** rename api key to SCOPE_DEFINITION_AGENT_ASSOCIATION ([d23557a](https://github.com/nullplatform/tofu-modules/commit/d23557a6ee88e7fa3020b3f1d9d1ace9bc93d0a5))
* only azure, no gcp ([b30004c](https://github.com/nullplatform/tofu-modules/commit/b30004ca346f93a34394aa5e88626d9f911b9d4e))
* only azure, no gcp ([4556484](https://github.com/nullplatform/tofu-modules/commit/455648472f21d30c573cc4816d4d86526ff73e10))
* Parameterize ingress controller configuration ([da89217](https://github.com/nullplatform/tofu-modules/commit/da892177af9f9da1510b93a8861409fc68153f89))
* **private_dns:** make virtual_network_links required and update example ([c75b08f](https://github.com/nullplatform/tofu-modules/commit/c75b08f1950fcff94db4a4a7a0d3c87809da72d7))
* **prometheus:** fix variable  ([#60](https://github.com/nullplatform/tofu-modules/issues/60)) ([aa177c0](https://github.com/nullplatform/tofu-modules/commit/aa177c0a321233198501558d907c97f2f9d2f731))
* **release:** fix commit message ([#131](https://github.com/nullplatform/tofu-modules/issues/131)) ([eb4e239](https://github.com/nullplatform/tofu-modules/commit/eb4e2395ce90ae9b2c08425ae99888c4b04cb02f))
* **release:** fix commit message ([#88](https://github.com/nullplatform/tofu-modules/issues/88)) ([5926b7b](https://github.com/nullplatform/tofu-modules/commit/5926b7b64b739e76c4d341db480dff86adb4088e))
* remove cross-variable validations ([8d4f5cd](https://github.com/nullplatform/tofu-modules/commit/8d4f5cdb3f5d0660b846b3e13c31b5b73d77ec80))
* remove cross-variable validations from agent and external_dns ([64f34c5](https://github.com/nullplatform/tofu-modules/commit/64f34c5156cc19b751ff2c985e2c8149c4a0adfc))
* remove unnecessary information from the readme ([ead4e24](https://github.com/nullplatform/tofu-modules/commit/ead4e242ffd4032e75311ea02bced16037006abe))
* remove version argument from git source module ([ed82438](https://github.com/nullplatform/tofu-modules/commit/ed82438851aa4188bf4d2c5b38c727d7e72f15ec))
* remove version argument from git source module ([041f1ba](https://github.com/nullplatform/tofu-modules/commit/041f1ba9aa6e0fa2425f53a60170338d55ff6fa4))
* rename agent API key to AGENT-ASSOCIATION with minimal permissions ([#92](https://github.com/nullplatform/tofu-modules/issues/92)) ([1fb44b2](https://github.com/nullplatform/tofu-modules/commit/1fb44b2c7ead437e082142157baad98ee98d6a66))
* rename api key to SCOPE_DEFINITION_AGENT_ASSOCIATION ([#117](https://github.com/nullplatform/tofu-modules/issues/117)) ([1ed79ba](https://github.com/nullplatform/tofu-modules/commit/1ed79ba7773d7b1f9792215623d4a3b40a988443))
* **route53:** disable output acm ([1dc1601](https://github.com/nullplatform/tofu-modules/commit/1dc1601a08178f562c3f51a18d4cc54ac7bf4a47))
* **route53:** disabled ACM ([413144d](https://github.com/nullplatform/tofu-modules/commit/413144d7e921cf9c81a6977b68e98645d96d391c))
* **scope_definition_agent_association:** add devops role to channel API key ([dc92016](https://github.com/nullplatform/tofu-modules/commit/dc9201607fa32be697b9f44bc022d2bee7789ee8))
* **scope_definition_agent_association:** use ops role instead of devops ([6012a4a](https://github.com/nullplatform/tofu-modules/commit/6012a4a0966511fc7ca3660aeb6821eed64fd6f6))
* **scope:** Add support for icon and annotations in service action spec definition ([#82](https://github.com/nullplatform/tofu-modules/issues/82)) ([5c7c1bb](https://github.com/nullplatform/tofu-modules/commit/5c7c1bbd677f3644c7e2df639e3cc25d336b30f0))
* **scope:** delete wrong file ([e0f3da8](https://github.com/nullplatform/tofu-modules/commit/e0f3da883d7ad24cbebd8de7fa2fc6bb4d1ee169))
* **scope:** fix naming reference scope association ([4f7059e](https://github.com/nullplatform/tofu-modules/commit/4f7059e067cf82c36d91467933f53406f2359e04))
* **scope:** fix naming reference scope association ([#75](https://github.com/nullplatform/tofu-modules/issues/75)) ([fec4c30](https://github.com/nullplatform/tofu-modules/commit/fec4c309122d02f3986f9bad171e04efaa08b729))
* **scope:** Fixing typo in annotation in scope definition module ([#85](https://github.com/nullplatform/tofu-modules/issues/85)) ([75a0d48](https://github.com/nullplatform/tofu-modules/commit/75a0d48a672152e3cf27c4ba907736d5fb75c634))
* secret ([6360c94](https://github.com/nullplatform/tofu-modules/commit/6360c94ceee3fcefec831f9cfeb12402e8857f2f))
* secret ([5f0885c](https://github.com/nullplatform/tofu-modules/commit/5f0885cade1428a7b0bf40c71cae7db76c474395))
* **service-definition:** simplify link specifications to use only links/ directory ([#149](https://github.com/nullplatform/tofu-modules/issues/149)) ([6db7d61](https://github.com/nullplatform/tofu-modules/commit/6db7d61765e8b08bafde28e3d682009b32f21fdd))
* standardize module variables and documentation ([9740af8](https://github.com/nullplatform/tofu-modules/commit/9740af81941c4add31dd1dfde3a000fe2ac44e5f))
* standardize module variables and documentation ([df30a24](https://github.com/nullplatform/tofu-modules/commit/df30a245c73b8a777d85c94200cdceefd1dcb521))
* **tofu-modules:** update varibles & readme ([8de37f1](https://github.com/nullplatform/tofu-modules/commit/8de37f1576b42935d114c57dc0686fbc33c2a186))
* **tofu:** fmt ([a9da839](https://github.com/nullplatform/tofu-modules/commit/a9da83956908a28fd9796a52768d0c8656d274f7))
* **tofu:** resolve conflicts ([013628f](https://github.com/nullplatform/tofu-modules/commit/013628f8e0530d20d0622f58008ea47b2970e54a))
* trigger release ([#150](https://github.com/nullplatform/tofu-modules/issues/150)) ([eaa6a66](https://github.com/nullplatform/tofu-modules/commit/eaa6a667032be9c330d84f70996f732d8444d812))
* unify cert-manager templates to handle all cloud providers ([e38db55](https://github.com/nullplatform/tofu-modules/commit/e38db55a01572d033ff8934e3e22a72b24f531f5))
* update cert-manager webhook config and improve README ([945f9a7](https://github.com/nullplatform/tofu-modules/commit/945f9a7b273408603fdbb01a11db5b7f6dc2a73f))
* update cert-manager webhook config and improve README ([cd36b2b](https://github.com/nullplatform/tofu-modules/commit/cd36b2bdf793224b3ba469b913cf525055319a18))
* update to v0.15.0 and replace resource_group_name for parent_id ([535b4e8](https://github.com/nullplatform/tofu-modules/commit/535b4e8d677b3186066ab1c06fd8f6c7f8a653e4))
* update to v0.15.0 and replace resource_group_name for parent_id ([#53](https://github.com/nullplatform/tofu-modules/issues/53)) ([fe32430](https://github.com/nullplatform/tofu-modules/commit/fe3243067b684682be22661c993033cb2094f4fc))
* use ternary operator instead of coalesce for null ([53ec48f](https://github.com/nullplatform/tofu-modules/commit/53ec48f2a4c990d2ca8b4159c11113a5057f708f))
* **workflows:** add condition branch release ([cc4b976](https://github.com/nullplatform/tofu-modules/commit/cc4b976b70fc72025ecd50e384c8c9a714f57cef))
* **workflows:** add condition branch release ([855d6f6](https://github.com/nullplatform/tofu-modules/commit/855d6f6d99a7847704b3a461e096a741d739e252))

## [1.22.1](https://github.com/nullplatform/tofu-modules/compare/v1.22.0...v1.22.1) (2026-01-23)


### Bug Fixes

* **agent:** add permission to verifiedpermissions ([#145](https://github.com/nullplatform/tofu-modules/issues/145)) ([369012e](https://github.com/nullplatform/tofu-modules/commit/369012e79199a5f70d696a5f2dc082ed76d208b4))
* **service-definition:** simplify link specifications to use only links/ directory ([#149](https://github.com/nullplatform/tofu-modules/issues/149)) ([6db7d61](https://github.com/nullplatform/tofu-modules/commit/6db7d61765e8b08bafde28e3d682009b32f21fdd))
* **tofu:** fmt ([a9da839](https://github.com/nullplatform/tofu-modules/commit/a9da83956908a28fd9796a52768d0c8656d274f7))
* **tofu:** resolve conflicts ([013628f](https://github.com/nullplatform/tofu-modules/commit/013628f8e0530d20d0622f58008ea47b2970e54a))
* trigger release ([#150](https://github.com/nullplatform/tofu-modules/issues/150)) ([eaa6a66](https://github.com/nullplatform/tofu-modules/commit/eaa6a667032be9c330d84f70996f732d8444d812))

## [1.22.2](https://github.com/nullplatform/tofu-modules/compare/v1.22.1...v1.22.2) (2026-01-22)


### Bug Fixes

* trigger release ([#150](https://github.com/nullplatform/tofu-modules/issues/150)) ([466546a](https://github.com/nullplatform/tofu-modules/commit/466546a9ca80d39037a02bcdb7acb8e41c9d6923))

## [1.22.1](https://github.com/nullplatform/tofu-modules/compare/v1.22.0...v1.22.1) (2026-01-22)


### Bug Fixes

* **agent:** add permission to verifiedpermissions ([#145](https://github.com/nullplatform/tofu-modules/issues/145)) ([369012e](https://github.com/nullplatform/tofu-modules/commit/369012e79199a5f70d696a5f2dc082ed76d208b4))
* **tofu:** fmt ([a9da839](https://github.com/nullplatform/tofu-modules/commit/a9da83956908a28fd9796a52768d0c8656d274f7))
* **tofu:** resolve conflicts ([013628f](https://github.com/nullplatform/tofu-modules/commit/013628f8e0530d20d0622f58008ea47b2970e54a))

## [1.22.0](https://github.com/nullplatform/tofu-modules/compare/v1.21.4...v1.22.0) (2026-01-21)


### Features

* **oci:** add support for oci ([#146](https://github.com/nullplatform/tofu-modules/issues/146)) ([ffaa72d](https://github.com/nullplatform/tofu-modules/commit/ffaa72d6d529ef168a422b7a4242a80a56920104))

## [1.21.4](https://github.com/nullplatform/tofu-modules/compare/v1.21.3...v1.21.4) (2026-01-21)


### Bug Fixes

* **chart-base:** add istio gateway security groups ([#143](https://github.com/nullplatform/tofu-modules/issues/143)) ([03fa7be](https://github.com/nullplatform/tofu-modules/commit/03fa7be2d3c9970b41935e683b5b58df71de27a1))

## [1.21.3](https://github.com/nullplatform/tofu-modules/compare/v1.21.2...v1.21.3) (2026-01-20)


### Bug Fixes

* **external-dns:** add rbac  ([#141](https://github.com/nullplatform/tofu-modules/issues/141)) ([ea5c5bb](https://github.com/nullplatform/tofu-modules/commit/ea5c5bbedb559b5d797185186204353a6d65186a))

## [1.21.2](https://github.com/nullplatform/tofu-modules/compare/v1.21.1...v1.21.2) (2026-01-19)


### Bug Fixes

* **base:** adding gateway name parameter ([#139](https://github.com/nullplatform/tofu-modules/issues/139)) ([a47a299](https://github.com/nullplatform/tofu-modules/commit/a47a299a890570a2960b90195247de9b45d0921a))

## [1.21.1](https://github.com/nullplatform/tofu-modules/compare/v1.21.0...v1.21.1) (2026-01-19)


### Bug Fixes

* **eks:** disable node security group to avoid ALB controller conflict ([#137](https://github.com/nullplatform/tofu-modules/issues/137)) ([8cbe80b](https://github.com/nullplatform/tofu-modules/commit/8cbe80b63d8edf2763d8bb1ed88e3b9b1b64a111))

## [1.21.0](https://github.com/nullplatform/tofu-modules/compare/v1.20.3...v1.21.0) (2026-01-15)


### Features

* **provider:** add support for azure devops ([#133](https://github.com/nullplatform/tofu-modules/issues/133)) ([e0125d9](https://github.com/nullplatform/tofu-modules/commit/e0125d921a288f866623661caf30d95be592e77d))

## [1.20.3](https://github.com/nullplatform/tofu-modules/compare/v1.20.2...v1.20.3) (2026-01-13)


### Bug Fixes

* **release:** fix commit message ([#131](https://github.com/nullplatform/tofu-modules/issues/131)) ([eb4e239](https://github.com/nullplatform/tofu-modules/commit/eb4e2395ce90ae9b2c08425ae99888c4b04cb02f))

## [1.20.2](https://github.com/nullplatform/tofu-modules/compare/v1.20.1...v1.20.2) (2026-01-12)


### Bug Fixes

* **external-dns:** fix external dns varaible type ([d44879c](https://github.com/nullplatform/tofu-modules/commit/d44879ceeae517c5dec097c7fa6d19e9b8bea06c))
* **external-dns:** fix external dns varaible type ([#128](https://github.com/nullplatform/tofu-modules/issues/128)) ([af26c59](https://github.com/nullplatform/tofu-modules/commit/af26c590b04089a7202d07a09ac6e6a30feaa06c))

## [1.20.1](https://github.com/nullplatform/tofu-modules/compare/v1.20.0...v1.20.1) (2026-01-12)


### Bug Fixes

* **external-dns:** set default value ([#126](https://github.com/nullplatform/tofu-modules/issues/126)) ([c652f64](https://github.com/nullplatform/tofu-modules/commit/c652f64adc2e04683c6495a2eaae8dd4a810e950))

## [1.20.0](https://github.com/nullplatform/tofu-modules/compare/v1.19.0...v1.20.0) (2026-01-12)


### Features

* service definition and service association channel ([#121](https://github.com/nullplatform/tofu-modules/issues/121)) ([44e6a8e](https://github.com/nullplatform/tofu-modules/commit/44e6a8e35bf3ed9cf42b0cd090eae215e62ff71a))

## [1.19.0](https://github.com/nullplatform/tofu-modules/compare/v1.18.0...v1.19.0) (2026-01-12)


### Features

* aks acr integration ([#120](https://github.com/nullplatform/tofu-modules/issues/120)) ([e2237b6](https://github.com/nullplatform/tofu-modules/commit/e2237b608ee9ccfabb40582582ab0e664640e13a))

## [1.18.0](https://github.com/nullplatform/tofu-modules/compare/v1.17.2...v1.18.0) (2026-01-12)


### Features

* **chart:** new version of charts ([#122](https://github.com/nullplatform/tofu-modules/issues/122)) ([83a8b39](https://github.com/nullplatform/tofu-modules/commit/83a8b399b836ca053fe8fc7b8689d1c198cd4e32))

## [1.17.2](https://github.com/nullplatform/tofu-modules/compare/v1.17.1...v1.17.2) (2026-01-12)


### Bug Fixes

* add disclaimer for registration_enabled usage ([ac1fd0a](https://github.com/nullplatform/tofu-modules/commit/ac1fd0a60b373656a922e5836a8f38fb5986e807))
* add validation for virtual_network_links ([76438d0](https://github.com/nullplatform/tofu-modules/commit/76438d08e1160f3d18e292f5bfa2c35ac7a3283e))
* make virtual_network_links required without default ([329f5a5](https://github.com/nullplatform/tofu-modules/commit/329f5a5a3c44d97239eb6875aa6784881a603e41))
* **private_dns:** make virtual_network_links required and update example ([c75b08f](https://github.com/nullplatform/tofu-modules/commit/c75b08f1950fcff94db4a4a7a0d3c87809da72d7))
* rename api key to SCOPE_DEFINITION_AGENT_ASSOCIATION ([#117](https://github.com/nullplatform/tofu-modules/issues/117)) ([1ed79ba](https://github.com/nullplatform/tofu-modules/commit/1ed79ba7773d7b1f9792215623d4a3b40a988443))

## [1.17.1](https://github.com/nullplatform/tofu-modules/compare/v1.17.0...v1.17.1) (2026-01-09)


### Bug Fixes

* **aks:** add network contributor ([0305ade](https://github.com/nullplatform/tofu-modules/commit/0305ade8dda6389a57e47cb4999abeb9e2362f5c))
* **aks:** add network contributor ([#114](https://github.com/nullplatform/tofu-modules/issues/114)) ([1542270](https://github.com/nullplatform/tofu-modules/commit/1542270b0f8a34ff52918bbdcbca42a75936f5e8))
* **azure-aks:** add role to vnet ([b40d33d](https://github.com/nullplatform/tofu-modules/commit/b40d33d4f80cbed3c552a5b4f7ac593c145ff5f3))
* **azure-aks:** principal_id variable ([6e3d54c](https://github.com/nullplatform/tofu-modules/commit/6e3d54c4bc00833161a03d4c65d0b9db8aba9b9f))
* **azure-aks:** principal_id variable ([6232bf0](https://github.com/nullplatform/tofu-modules/commit/6232bf0f44c7c99377b220f28895bd7a52039b35))
* **base-gateways:** add annottaion to LB use subnet private ([8e3b09e](https://github.com/nullplatform/tofu-modules/commit/8e3b09e0a57f0a86e0494145b69d8da0540123d7))
* **base:** update version chart ([0bc1fbd](https://github.com/nullplatform/tofu-modules/commit/0bc1fbdd45ae873a42c13c7a8618bd5f54f140ca))
* **base:** update version chart ([#116](https://github.com/nullplatform/tofu-modules/issues/116)) ([26a1034](https://github.com/nullplatform/tofu-modules/commit/26a1034eec4285cb3fca8f8904c0a4d2da76524f))

## [1.17.0](https://github.com/nullplatform/tofu-modules/compare/v1.16.0...v1.17.0) (2026-01-07)


### Features

* **scope:** parameterize repository values ([#110](https://github.com/nullplatform/tofu-modules/issues/110)) ([297c1a3](https://github.com/nullplatform/tofu-modules/commit/297c1a3ed788faf13cc9ef76c9480ad2227db9dc))

## [1.16.0](https://github.com/nullplatform/tofu-modules/compare/v1.15.1...v1.16.0) (2026-01-05)


### Features

* **agent:** add config external-dns to aws config ([3d69436](https://github.com/nullplatform/tofu-modules/commit/3d694365764e92a23a0c1f2c2a076c644801d2d0))
* **agent:** add config external-dns to aws config ([#105](https://github.com/nullplatform/tofu-modules/issues/105)) ([1a828f9](https://github.com/nullplatform/tofu-modules/commit/1a828f97f671ea4dfcdf34bb49ee7e21ec5dac43))
* **agent:** move identical variables to global configuration ([2b78254](https://github.com/nullplatform/tofu-modules/commit/2b78254ab4d16251ac3d1c4504189b5ce3201841))

## [1.15.1](https://github.com/nullplatform/tofu-modules/compare/v1.15.0...v1.15.1) (2025-12-30)


### Bug Fixes

* **gke:** add protection destroy as false ([#102](https://github.com/nullplatform/tofu-modules/issues/102)) ([26f0788](https://github.com/nullplatform/tofu-modules/commit/26f07883fd2bf6d0f351755d0e730fecc281e49a))

## [1.15.0](https://github.com/nullplatform/tofu-modules/compare/v1.14.0...v1.15.0) (2025-12-30)


### Features

* **external-dns:** resolve conflicts ([4f71b63](https://github.com/nullplatform/tofu-modules/commit/4f71b6359456c3c4e201deec7aed30c6b72092bd))
* **tofu:** run fmt ([371342b](https://github.com/nullplatform/tofu-modules/commit/371342bf77151e4f5c70e4e3a3a27c605af16454))

## [1.14.0](https://github.com/nullplatform/tofu-modules/compare/v1.13.0...v1.14.0) (2025-12-29)


### Features

* **azure:** Add private DNS zone module ([#90](https://github.com/nullplatform/tofu-modules/issues/90)) ([5d4399e](https://github.com/nullplatform/tofu-modules/commit/5d4399ea5f1823cc5d96c1075083b74d426b4ff1))


### Bug Fixes

* rename agent API key to AGENT-ASSOCIATION with minimal permissions ([#92](https://github.com/nullplatform/tofu-modules/issues/92)) ([1fb44b2](https://github.com/nullplatform/tofu-modules/commit/1fb44b2c7ead437e082142157baad98ee98d6a66))

## [1.13.0](https://github.com/nullplatform/tofu-modules/compare/v1.12.10...v1.13.0) (2025-12-29)


### Features

* **external-dns:** support multi external dns ([#97](https://github.com/nullplatform/tofu-modules/issues/97)) ([3ddbd8e](https://github.com/nullplatform/tofu-modules/commit/3ddbd8ebf152722be693539493229a6f6098a27c))

## [1.12.10](https://github.com/nullplatform/tofu-modules/compare/v1.12.9...v1.12.10) (2025-12-23)


### Bug Fixes

* **cert manager:** fix linter ([#95](https://github.com/nullplatform/tofu-modules/issues/95)) ([260d4c2](https://github.com/nullplatform/tofu-modules/commit/260d4c246c25f924fe49ead3801562cf188b25f4))

## [1.12.9](https://github.com/nullplatform/tofu-modules/compare/v1.12.8...v1.12.9) (2025-12-23)


### Bug Fixes

* update to v0.15.0 and replace resource_group_name with parent_id ([#53](https://github.com/nullplatform/tofu-modules/issues/53)) ([fe32430](https://github.com/nullplatform/tofu-modules/commit/fe3243067b684682be22661c993033cb2094f4fc))

## [1.12.8](https://github.com/nullplatform/tofu-modules/compare/v1.12.7...v1.12.8) (2025-12-22)


### Bug Fixes

* **release:** fix commit message ([#88](https://github.com/nullplatform/tofu-modules/issues/88)) ([5926b7b](https://github.com/nullplatform/tofu-modules/commit/5926b7b64b739e76c4d341db480dff86adb4088e))

## [1.12.7](https://github.com/nullplatform/tofu-modules/compare/v1.12.6...v1.12.7) (2025-12-18)


### Bug Fixes

* **scope:** Fixing typo in annotation in scope definition module ([#85](https://github.com/nullplatform/tofu-modules/issues/85)) ([75a0d48](https://github.com/nullplatform/tofu-modules/commit/75a0d48a672152e3cf27c4ba907736d5fb75c634))

## [1.12.6](https://github.com/nullplatform/tofu-modules/compare/v1.12.5...v1.12.6) (2025-12-18)


### Bug Fixes

* **scope:** Add support for icon and annotations in service action spec definition ([#82](https://github.com/nullplatform/tofu-modules/issues/82)) ([5c7c1bb](https://github.com/nullplatform/tofu-modules/commit/5c7c1bbd677f3644c7e2df639e3cc25d336b30f0))

## [1.12.5](https://github.com/nullplatform/tofu-modules/compare/v1.12.4...v1.12.5) (2025-12-15)


### Bug Fixes

* **external-dns:** fix gsa_email variable ([d0e20fe](https://github.com/nullplatform/tofu-modules/commit/d0e20fec9c8bd60a57431009b9d3f6993f37c8af))

## [1.12.4](https://github.com/nullplatform/tofu-modules/compare/v1.12.3...v1.12.4) (2025-12-12)


### Bug Fixes

* **agent:** add extra-config variable ([1ef4815](https://github.com/nullplatform/tofu-modules/commit/1ef4815aff0c4a6ee10759de2ff4262e2955cfac))
* **agent:** fix repos extra variable ([dbda999](https://github.com/nullplatform/tofu-modules/commit/dbda999d04e6c5d2657653925f13b22ed952ec79))
* **agent:** fix values tmpl ([b1044bc](https://github.com/nullplatform/tofu-modules/commit/b1044bc4ce0ecb89c931cf12ef7520e55ca5633a))
* **agent:** fix values tmpl ([26721ab](https://github.com/nullplatform/tofu-modules/commit/26721ab656ec068f52b3d9945c1a15ab0c1acf4a))
* **agent:** fix values tmpl ([3640da2](https://github.com/nullplatform/tofu-modules/commit/3640da2316ed55630cda4b3f2700ba91bae0db0f))
* **agent:** fix var repo extra ([bf989fa](https://github.com/nullplatform/tofu-modules/commit/bf989faa6817e7c25407c93543a44a81633b8288))
* **agent:** refactor values agent ([46023a8](https://github.com/nullplatform/tofu-modules/commit/46023a8b68174e547695d7c3678d15b41fefffb3))
* **agent:** upgrade helm chart version ([596e05f](https://github.com/nullplatform/tofu-modules/commit/596e05f961ecd32fa8f00796f5f4cf4592cfd43b))
* **alb-controller:** add perdiod sync variable ([f96191b](https://github.com/nullplatform/tofu-modules/commit/f96191bc4b7c4c7b1d15a55924dbc2128f2620a5))
* **alb-controller:** add policy to alb controller ([63596f3](https://github.com/nullplatform/tofu-modules/commit/63596f30cf3da80fbdf2a07b22dfaa3411c02d82))
* **asset:** fix naming policies ([743e5ba](https://github.com/nullplatform/tofu-modules/commit/743e5ba5ea99b7fe5938b6a9a412d92cd8d840d4))
* **asset:** fix naming policies ([6ecff04](https://github.com/nullplatform/tofu-modules/commit/6ecff04b4825a93bb2b9e83d53c8e41e07f9691c))
* **base-iam:** fix naming policies to multiple cluster ([c1d5701](https://github.com/nullplatform/tofu-modules/commit/c1d5701301797eb163c2cdbb05d194ba84201c85))
* **base:** fix naming k8s-provider ([d89fe19](https://github.com/nullplatform/tofu-modules/commit/d89fe1942e4f6127718d8430d98674fd9da044f3))
* **base:** upgrade version helm ([87c1aae](https://github.com/nullplatform/tofu-modules/commit/87c1aae7e7235a75f3572cad276db1c00a14aa52))

## [1.12.3](https://github.com/nullplatform/tofu-modules/compare/v1.12.2...v1.12.3) (2025-12-06)


### Bug Fixes

* **scope:** delete wrong file ([e0f3da8](https://github.com/nullplatform/tofu-modules/commit/e0f3da883d7ad24cbebd8de7fa2fc6bb4d1ee169))
* **scope:** fix naming reference scope association ([4f7059e](https://github.com/nullplatform/tofu-modules/commit/4f7059e067cf82c36d91467933f53406f2359e04))
* **scope:** fix naming reference scope association ([#75](https://github.com/nullplatform/tofu-modules/issues/75)) ([fec4c30](https://github.com/nullplatform/tofu-modules/commit/fec4c309122d02f3986f9bad171e04efaa08b729))

## [1.12.2](https://github.com/nullplatform/tofu-modules/compare/v1.12.1...v1.12.2) (2025-11-26)


### Bug Fixes

* **external-dns:** change policy to variable ([#73](https://github.com/nullplatform/tofu-modules/issues/73)) ([739ae02](https://github.com/nullplatform/tofu-modules/commit/739ae02d4d8cab9bf37a1b4e020fcde62c9df18c))

## [1.12.1](https://github.com/nullplatform/tofu-modules/compare/v1.12.0...v1.12.1) (2025-11-26)


### Bug Fixes

* **base:** remove provider nullplatform ([#69](https://github.com/nullplatform/tofu-modules/issues/69)) ([bb376e9](https://github.com/nullplatform/tofu-modules/commit/bb376e9aa0128f5e3f485294700a212380e219eb))

## [1.12.0](https://github.com/nullplatform/tofu-modules/compare/v1.11.0...v1.12.0) (2025-11-25)


### Features

* **main:** add PR to execute linter & docs ([81ebff6](https://github.com/nullplatform/tofu-modules/commit/81ebff67c08200b31b55ba6974d31f4b6a245b57))
* **main:** rollback ([1681548](https://github.com/nullplatform/tofu-modules/commit/16815482cd040b4e4ba4259b4342c7bafb3be98a))
* **scope-definition-agent:** fix data http templates ([f89a4ef](https://github.com/nullplatform/tofu-modules/commit/f89a4ef56d5c281b8f3a2e993f1c14fbf3b59a4c))

## [1.11.0](https://github.com/nullplatform/tofu-modules/compare/v1.10.1...v1.11.0) (2025-11-19)


### Features

* edit readme ([#63](https://github.com/nullplatform/tofu-modules/issues/63)) ([12cb339](https://github.com/nullplatform/tofu-modules/commit/12cb339e7bf54de460251abb328da95de54e5d39))

## [1.10.1](https://github.com/nullplatform/tofu-modules/compare/v1.10.0...v1.10.1) (2025-11-19)


### Bug Fixes

* **prometheus:** fix variable  ([#60](https://github.com/nullplatform/tofu-modules/issues/60)) ([aa177c0](https://github.com/nullplatform/tofu-modules/commit/aa177c0a321233198501558d907c97f2f9d2f731))

## [1.10.0](https://github.com/nullplatform/tofu-modules/compare/v1.9.0...v1.10.0) (2025-11-17)


### Features

* **release:** edit yaml release ([#58](https://github.com/nullplatform/tofu-modules/issues/58)) ([b50b97e](https://github.com/nullplatform/tofu-modules/commit/b50b97ed0212e6cded7596ed5c91d2f7d75ea218))

## [1.9.0](https://github.com/nullplatform/tofu-modules/compare/v1.8.0...v1.9.0) (2025-11-17)


### Features

* **prometheus:** edit variables ([#56](https://github.com/nullplatform/tofu-modules/issues/56)) ([45ddc88](https://github.com/nullplatform/tofu-modules/commit/45ddc880afc48a4f93de6f132603ad3a4e73dfb1))

## [1.8.0](https://github.com/nullplatform/tofu-modules/compare/v1.7.0...v1.8.0) (2025-11-12)


### Features

* **scope-definition:** fix agent telemetry config ([#50](https://github.com/nullplatform/tofu-modules/issues/50)) ([cd59a81](https://github.com/nullplatform/tofu-modules/commit/cd59a81e4479d8761be1f4988e7d137dd7f126bf))

## [1.7.0](https://github.com/nullplatform/tofu-modules/compare/v1.6.0...v1.7.0) (2025-11-12)


### Features

* **agent:** add azure to agent ([0bde56c](https://github.com/nullplatform/tofu-modules/commit/0bde56cf16e18934d419d8185ef40007fc4cad61))
* **agent:** fix cert-manager name templates ([a3913db](https://github.com/nullplatform/tofu-modules/commit/a3913dbe5e2737e724a1c7c561c33ab4dd558a8c))
* **external-dns:** add validation to variables ([c4c3e36](https://github.com/nullplatform/tofu-modules/commit/c4c3e364923802d118ab7557ce545f356bb59275))
* **external-dns:** add validation to variables ([d091739](https://github.com/nullplatform/tofu-modules/commit/d0917390351562ac3449e4f562661295f3ce58fc))
* **external-dns:** fix init script ([a2c35fd](https://github.com/nullplatform/tofu-modules/commit/a2c35fd598cc57e212cf6e9b18e52ad6d5387224))
* **tofu:** resolve conflicts ([61692e3](https://github.com/nullplatform/tofu-modules/commit/61692e3ec78365d96f9cec2eae419768731cf12b))

## [1.6.0](https://github.com/nullplatform/tofu-modules/compare/v1.5.3...v1.6.0) (2025-11-11)


### Features

* add support for prometheus operator ([5e85aa1](https://github.com/nullplatform/tofu-modules/commit/5e85aa1bc1c49c926d1747ddd670d046b4d7e5d6))
* add support for Prometheus Operator ([f1c6e08](https://github.com/nullplatform/tofu-modules/commit/f1c6e080b1be49f575e625202c72a6aa03011ea9))
* add support for Prometheus Operator ([9e1db19](https://github.com/nullplatform/tofu-modules/commit/9e1db198732650b24e06e76592765c647b0d35b5))
* add support for Prometheus Operator ([11557ea](https://github.com/nullplatform/tofu-modules/commit/11557eabc0950e07b216e7c4eb7fb78a8b48dd8c))

## [1.5.3](https://github.com/nullplatform/tofu-modules/compare/v1.5.2...v1.5.3) (2025-11-07)


### Bug Fixes

* update cert-manager webhook config and improve README ([945f9a7](https://github.com/nullplatform/tofu-modules/commit/945f9a7b273408603fdbb01a11db5b7f6dc2a73f))
* update cert-manager webhook config and improve README ([cd36b2b](https://github.com/nullplatform/tofu-modules/commit/cd36b2bdf793224b3ba469b913cf525055319a18))

## [1.5.2](https://github.com/nullplatform/tofu-modules/compare/v1.5.1...v1.5.2) (2025-11-06)


### Bug Fixes

* **cert-manager:** fix namespace error and improve configuration ([4af6c98](https://github.com/nullplatform/tofu-modules/commit/4af6c98918e309b94e5e03a499316c473ed37821))
* common changes readme ([3207ce2](https://github.com/nullplatform/tofu-modules/commit/3207ce234f7f0e20f02748ab7026a6b1841bdb7a))
* external-dns secret and namespace depends ([4ee0bbd](https://github.com/nullplatform/tofu-modules/commit/4ee0bbd3b56872b85b9589c177d1e26e868506eb))
* only azure, no gcp ([4556484](https://github.com/nullplatform/tofu-modules/commit/455648472f21d30c573cc4816d4d86526ff73e10))
* remove version argument from git source module ([ed82438](https://github.com/nullplatform/tofu-modules/commit/ed82438851aa4188bf4d2c5b38c727d7e72f15ec))
* remove version argument from git source module ([041f1ba](https://github.com/nullplatform/tofu-modules/commit/041f1ba9aa6e0fa2425f53a60170338d55ff6fa4))
* secret ([5f0885c](https://github.com/nullplatform/tofu-modules/commit/5f0885cade1428a7b0bf40c71cae7db76c474395))

## [1.5.1](https://github.com/nullplatform/tofu-modules/compare/v1.5.0...v1.5.1) (2025-11-05)


### Bug Fixes

* remove unnecessary information from the readme ([ead4e24](https://github.com/nullplatform/tofu-modules/commit/ead4e242ffd4032e75311ea02bced16037006abe))
* standardize module variables and documentation ([9740af8](https://github.com/nullplatform/tofu-modules/commit/9740af81941c4add31dd1dfde3a000fe2ac44e5f))
* standardize module variables and documentation ([df30a24](https://github.com/nullplatform/tofu-modules/commit/df30a245c73b8a777d85c94200cdceefd1dcb521))

## [1.5.0](https://github.com/nullplatform/tofu-modules/compare/v1.4.0...v1.5.0) (2025-11-04)


### Features

* **agent:** add multi cloud ([adbaa97](https://github.com/nullplatform/tofu-modules/commit/adbaa976964f8531cdf372985378e82ff225375a))
* **agent:** fix image tag variable ([667da65](https://github.com/nullplatform/tofu-modules/commit/667da65400dc18b5758679dd724c0de6b3586ab5))
* **agent:** fix readme ([96faf72](https://github.com/nullplatform/tofu-modules/commit/96faf7202f3d61b276a80744db80f538f4fa2369))
* **agent:** fix template default ([dc225b5](https://github.com/nullplatform/tofu-modules/commit/dc225b5a1c16a7f6fc1e29537ad4dc74df76dca1))
* **agent:** fix template default ([9ac324c](https://github.com/nullplatform/tofu-modules/commit/9ac324c114baa4be482d06779f067b9c10dff051))
* **agent:** move image-tag variable ([f9ac77b](https://github.com/nullplatform/tofu-modules/commit/f9ac77b09422040b97b25609032afc56373b572d))
* **agent:** move image-tag variable ([8c0c483](https://github.com/nullplatform/tofu-modules/commit/8c0c483592acd44ada02c81ea4346f2716c8696f))
* **agent:** tofu fmt ([e5aa787](https://github.com/nullplatform/tofu-modules/commit/e5aa787583afb204ce32e4b22873bcfa1297d997))
* **aws-iam:** add aws iam module ([8f53196](https://github.com/nullplatform/tofu-modules/commit/8f53196411950664824cd1a4baece7fa8c986df4))
* **aws-iam:** add aws iam module ([f728ef3](https://github.com/nullplatform/tofu-modules/commit/f728ef3aed084baffb5e639768041a821601b52a))
* **aws-iam:** add output to role arn ([ac7676d](https://github.com/nullplatform/tofu-modules/commit/ac7676d9ce5f652ed3c9b46450bcae2149fffcc8))

## [1.4.0](https://github.com/nullplatform/tofu-modules/compare/v1.3.1...v1.4.0) (2025-10-30)


### Features

* add agent, scope, and scope association ([f508cca](https://github.com/nullplatform/tofu-modules/commit/f508ccaf263835b7fc53263bbce4d142976d1cb4))
* add agnostic agent ([1d1d5e3](https://github.com/nullplatform/tofu-modules/commit/1d1d5e35720864e035f3995237365392b453f83e))
* add scope definition agent association ([416526d](https://github.com/nullplatform/tofu-modules/commit/416526d72150a2a1adba90263c1d67955e623ce3))
* add scope definition modules ([eba0ba3](https://github.com/nullplatform/tofu-modules/commit/eba0ba36e80fdd8245523e78fc376e24930039f3))
* pipeline ([25c0a28](https://github.com/nullplatform/tofu-modules/commit/25c0a288cdfe4384d888935159ce7d1de126706b))

## [1.3.1](https://github.com/nullplatform/tofu-modules/compare/v1.3.0...v1.3.1) (2025-10-27)


### Bug Fixes

* **workflows:** add condition branch release ([cc4b976](https://github.com/nullplatform/tofu-modules/commit/cc4b976b70fc72025ecd50e384c8c9a714f57cef))
* **workflows:** add condition branch release ([855d6f6](https://github.com/nullplatform/tofu-modules/commit/855d6f6d99a7847704b3a461e096a741d739e252))

## [1.3.0](https://github.com/nullplatform/tofu-modules/compare/v1.2.0...v1.3.0) (2025-10-27)


### Features

* add aks module ([ef313d9](https://github.com/nullplatform/tofu-modules/commit/ef313d9077f3d69e207fcff5d3f4aabd64b539d0))
* add data tenant id ([993dd15](https://github.com/nullplatform/tofu-modules/commit/993dd15bfd9320f753bf26fd43d5da972bec6331))
* add output vnet ([d20b871](https://github.com/nullplatform/tofu-modules/commit/d20b871bc710eee36700b2a1e3784384820f1a9e))
* add sku input ([01450ac](https://github.com/nullplatform/tofu-modules/commit/01450ac176e4f0f96621038e5f7158ed5b6dc5f2))
* add sku input ([78107a9](https://github.com/nullplatform/tofu-modules/commit/78107a9b62188bc4bda3cc1fe29f4c26de114b40))
* add sku input ([faa4700](https://github.com/nullplatform/tofu-modules/commit/faa470032de8b8b8ba7b9b4ee47c79ef0229b558))
* aks module release ([51ff70d](https://github.com/nullplatform/tofu-modules/commit/51ff70d0c557dcd6a9f3001d4186564a6ea3d545))
* edit acr georeplication ([1448c56](https://github.com/nullplatform/tofu-modules/commit/1448c567d3fa4a4472fdba7eb5e9226fe280a72c))
* edit count of nodes ([bd46b4c](https://github.com/nullplatform/tofu-modules/commit/bd46b4ce4b069e994d67dbe9b00fcd984a51d846))
* edit node agents_pool_max_surge ([bca13bd](https://github.com/nullplatform/tofu-modules/commit/bca13bdc5fd9d76375dbb915c907b0ea61cee54a))
* edit node agents_pool_max_surge ([3a5bec1](https://github.com/nullplatform/tofu-modules/commit/3a5bec153844bfc1f20e462a589c03f255316eab))
* edit provider aks ([c6817f2](https://github.com/nullplatform/tofu-modules/commit/c6817f21bbc0c67273468c9bad2b0ef177142b8c))
* edit var ([b4e869f](https://github.com/nullplatform/tofu-modules/commit/b4e869f9f87b92e835a4316446c471c8262f5669))
* edit var ([57da603](https://github.com/nullplatform/tofu-modules/commit/57da603063c845fdac5db2cf4f06adc75381b9c1))
* edit variables ([44c9674](https://github.com/nullplatform/tofu-modules/commit/44c967493a9c98dcd2c03bb8d6a9b74d5d6d9460))
* edit variables ([60f47ed](https://github.com/nullplatform/tofu-modules/commit/60f47edcfdb5e45738e8928ce87ff2e6bbfc2861))
* edit variables ([cc370e5](https://github.com/nullplatform/tofu-modules/commit/cc370e5a8d18cfbe0a77c4ea804449a684c747dc))
* edit variables ([3002fcc](https://github.com/nullplatform/tofu-modules/commit/3002fccdfdb33a90657d74b469d7664c423a15b5))
* edit variables ([99cf67a](https://github.com/nullplatform/tofu-modules/commit/99cf67a6236e279537eabfbfda884c7146a9187e))
* false redundancy ([199d908](https://github.com/nullplatform/tofu-modules/commit/199d908e8bc7bdaf40ecceb3e28f539a124c892a))
* false redundancy ([8c5b585](https://github.com/nullplatform/tofu-modules/commit/8c5b5855fba5826d3052523fa1534907dbf09fbe))
* false redundancy ([7040143](https://github.com/nullplatform/tofu-modules/commit/7040143f3b0519ec4b70b325d403f75e10821f82))
* oid enabled ([0f48c61](https://github.com/nullplatform/tofu-modules/commit/0f48c61374a18d62c99b5c5c1ed332d2da490fd2))

## [1.2.0](https://github.com/nullplatform/tofu-modules/compare/v1.1.9...v1.2.0) (2025-10-22)


### Features

* add action of release ([cbee19a](https://github.com/nullplatform/tofu-modules/commit/cbee19a5409a914f6468313f650b0b797f29d82e))
* add action of release ([8f695ed](https://github.com/nullplatform/tofu-modules/commit/8f695edf0805a35fbc430c23db60fbadce2da3ec))
* add action of release ([9421b67](https://github.com/nullplatform/tofu-modules/commit/9421b678a8b627b414de068d8ab6a466e4b13a12))
