## 0.86 (2025-06-20)

- Reviving the package for GAP 4.14.0. Protecting the internal Stack and Queue implementation by @. Since they are part of a storage framework, it is not immediate to switch to the external implementations. NrEdgesInHasseDiagramOfDClasses removed as PartialOrderOfDClasses is a Hasse diagram now.

## 0.85 (2019-03-26)

- GAP 4.10 compatibility. Removed SgpDec as dependency. Tests added.

## 0.84 (2017-02-05)

- Logging utility functions moved from SgpDec. Bugfix in NrEdgesInHasseDiagramOfDClasses.

## 0.83 (2017-01-27)

- PriorityQueueLossless added for storing dropped items on disk. It enables enumerating semigroups by size. Refactoring the embedding search function. Revised and added search scripts.

## 0.82 (2016-07-20)

- Significant speed up (2x for T4->T5) for MulTabEmbeddingsUpToConjugation.

## 0.81 (2016-07-17)

- Added MulTabEmbeddingsUpToConjugation and MulTabEmbeddingsUpToConjugation.

## 0.80 (2016-07-08)

- Fixing GrpTag, not to fail when SmallGroupId is not available.

## 0.79 (2016-05-17)

- Fixing regression in the ideal part: no more duplicates of upper torso semigroups.. Rearranging the enumeration scripts.

## 0.78 (2016-03-24)

- Revising the code for enumerating subsemigroups along an ideal. Mainly driven by the need for simplifying downstream enumeration scripts.

## 0.77 (2016-03-17)

- Reorganize the code for semigroup embeddings. Shell-scripts for handling semigroup databases.

## 0.76 (2016-02-26)

- Update release following GAP 4.8.2.

## 0.75 (2016-02-25)

- Constructing embeddings by backtrack does less checks by checking the new element first. This makes the calculation several times faster.

## 0.74 (2016-02-23)

- Revising multiplication table invariants. These functions now take simple matrices instead of MulTab objects.

## 0.73 (2016-02-22)

- Revising the conjugacy class representative code.

## 0.72 (2016-02-13)

- Clean up of the independent set functions.

## 0.71 (2016-01-27)

- Getting rid of duplicated code in the independent set search algorithms by proper abstraction.

## 0.70 (2016-01-25)

- Using a simple array instead of hashing in SubTableMatchingSearch. It gives speedup and it is compatible with Orb 4.7.5.

## 0.69 (2016-01-13)

- Adding SubSgpsIncreasingOrder and simplifying the minimal extensions function (consequently removing SubSgpsGenSetsByMinExtensions).

## 0.68 (2016-01-13)

- FileSubsemigroupsInDecreasingOrder added.

## 0.67 (2016-01-13)

- Adding SubSgpsInDecreasingOrder using MaximalSubsemigroups.

## 0.66 (2016-01-11)

- Standardized filename extensions in filing. Improving sgp tags.

## 0.65 (2016-01-09)

- Removed dependency: the Dust package. The storage code (stacks. queues, etc.) is included here now.

## 0.64 (2016-01-09)

- FileSubsemigroups rewritten, especially the isomorphism and anti-isomorphim checks.

## 0.63 (2016-01-07)

- SgpsContaining added. Minimal extensions algorithm does not include the seed subsgp automatically.

## 0.62 (2016-01-05)

- AutomorphsimGroup now works for semigroups. GrpTag, SgpsDatabase added for the classification of Sub(T4).

## 0.61 (2016-01-02)

- TagSgpsFromFile added.

## 0.60 (2016-01-02)

- Classification now checks for 3-nilpotency.

## 0.59 (2016-01-02)

- Added simplified classification method: SaveTaggedSgps. Separating textprocessing and semigroup tagging code.

## 0.58 (2015-12-28)

- Replacing AssociativeList with the included classifier in multab.gi and embedding.gi.

## 0.57 (2015-12-25)

- Replacing DUST's indexed blist storage solution with a simple array of hashtables.

## 0.56 (2015-12-22)

- Closure functions again have the same signature. Renamings and rearrangings in closure.g*.

## 0.55 (2015-12-21)

- Closure algorithms got simplified.

## 0.54 (2015-12-20)

- CLOSED BRANCH! Major architectural change: closure algorithms work on lists only, and blists are only used for storage. (It turns out that plain lists are lot slower.)

## 0.53 (2015-12-18)

- IsIndependentSet -> IsSgpIndependentSet, to be mathematically precise. Removing experimental code (Expressible).

## 0.52 (2015-12-16)

- AutGrpOfMulTab added. Removing unused code from filing. GAP 4.8 is now a dependence.

## 0.51 (2015-12-08)

- Scripts: added 3-nilpotent and maximal subsemigroups. Separating scripts into folders (partially).

## 0.50 (2015-12-01)

- Regression fix in IsIsomorphiMulTab. Renaming: SortedElements -> Elts. Code review in minextensions.

## 0.49 (2015-11-30)

- Separating conjugacy code for better readability and maintainability. Simplifying filing.

## 0.48 (2015-11-24)

- Fixes for isomorphism functions. File reanming: isomorphism -> embedding.

## 0.47 (2015-11-24)

- Complete rework of functions to create semigroup embeddings.

## 0.46 (2015-11-24)

- Adding PotentiallyIsomorphicMulTabs.

## 0.45 (2015-11-24)

- Reworking SubTableMatchingSearch to give all possible embeddings.

## 0.44 (2015-11-10)

- Adding IsDeadEnd, revamping SubSgpdByMinimalGenSets, code cleaning.

## 0.43 (2015-10-07)

- Implementing the canonical construction path method for finding independent sets.

## 0.42 (2015-09-30)

- Making the small degree diagram semigroup classification self-contained (included a partitioned binary relation implementation). Several little improvements for calculating independent sets.

## 0.41 (2015-08-12)

- Implementing a more efficient conjugacy class representative calculation. Many changes around the independent generator set code.

## 0.40 (2015-07-29)

- Doing the reflexive transitive reduction of the partial order in filing -> no direct dependence on the digraphs package. Inverse semigroups are also classified.

## 0.39 (2015-07-26)

- Making tests short-circuit in isomorphism code. Making more tests based on Green's classes data.

## 0.38 (2015-07-25)

- Introducing the Classify function to abstract several isomorphism class functions.

## 0.37 (2015-07-23)

- Several improvements of filing and scripts for enumeration/classification. Improving bitstring encoding, NOT BACKWARD COMPATIBLE! New calculation for the number of edges in the Hasse diagram.

## 0.36 (2015-01-27)

- New dependency: graphs package. Working on enumerating scripts and related changes.

## 0.35 (2014-12-04)

- Bugfix: no formatting in SaveIndicatorSets. Code clean-up for n-generated subsemigroups.

## 0.34 (2014-12-02)

- Isomorphism, anti-isomorphism filing done properly in small degree scripts and in GensFileAntiAndIsomClasses.

## 0.33 (2014-10-29)

- Working on the Sub(T4) recalculation script. Bugfix: general subsets have to be closed by SubSgpsByMinExtensions.

## 0.32 (2014-10-20)

- Adding functions for testing anti-isomorphism. Bugfix in SubTableMatchingSearch (checking for missing profiles). Fixes in scripts.

## 0.31 (2014-10-06)

- Reviewing the isomorphism checking code. A bit of abstraction turned it into an embedding algorithm. Many functions became (pseudo)polymorphic, so they take both plain matrices and MulTab objects. A 'user interface' is fitted: high-level functions AllSubsemigroups and ConjugacyClassRepSubsemigroups.

## 0.30 (2014-08-31)

- GensFileIsomClasses rewritten.

## 0.29 (2014-08-16)

- Further extensions to SgpTag.

## 0.28 (2014-08-01)

- SgpTag extended with the number of maximal D-classes and the number of edges in the Hasse diagram of D-classes. Fixing misleading peek in SubSgpsByMinExtensions.

## 0.27 (2014-07-12)

- Added scripts for enumerating small-degree diagram semigroups. Improved filing.

## 0.26 (2014-06-28)

- Improved semigroup tagging and new memory-efficient filing function.

## 0.25 (2014-06-27)

- Improving the calculation of isomorphism classes: preclassifying by the number of idempotents.

## 0.24 (2014-06-07)

- Further tree pruning in SubSgpsByMinExtensions by the normalizer of the subsemigroup (James). Checkpointing added. Several small corrections, commenting.

## 0.23 (2014-03-24)

- SubSemiTestAll/TestInstall now separated. Symmetric inverse semigroup test added. Unnecessary (used only once) functions removed.

## 0.22 (2014-02-28)

- Improved filing script.

## 0.21 (2014-02-24)

- SubSgpsByUpperTorsos is the correct function name.

## 0.20 (2014-02-23)

- Separating upper torso calculation. It is now possible not to calculate the ideal again (empty upper torso can be removed).

## 0.19 (2014-02-21)

- BUGFIX: in minextensions.gi, removing the generators already in the baseset caused losses in the torso calculation.

## 0.18 (2014-02-17)

- IsomorphismSemigroups -> IsomorphismSemigroupsByMulTabs, following upstream changes.

## 0.17 (2014-02-09)

- NilPotencyDegreeByMulTabs added.

## 0.16 (2014-02-03)

- IndicatorSetByElements (and similar functions in the gang) can now take multiplication tables as arguments instead of the sorted elements. Just for convenience.

## 0.15 (2014-01-13)

- Reviewing the isomorphism code. ElementProfileLookup added. Improving Is3NilPotent.

## 0.14

- Just renaming to follow the paper's terminology: minimal closures to minimal extensions.

## 0.13 (2014-01-03)

- Removing equivalent generators is done only once for the minimal closure method.

## 0.12 (2014-01-03)

- Added possibility to search for minimal generating sets as well. This required the minimal closure search to change to breadth-first. Depth-first is still possible.

## 0.11 (2013-12-27)

- Reviewing closures. Finetuning logging and dumping in SubSgpsByMinClosures. FullSet, EmptySet now attributes.

## 0.10 (2013-12-22)

- 1Extension renamed to MinClosure.

## 0.9 (2013-12-20)

- IsClosedSubTable added. SubSgpsBy1ExtensionsParametrized added enabling faster torso combinations. The empty semigroup is returned now as a subsemigroup.

## 0.8 (2013-12-13)

- IsomorphismMulTabs, IsomorphismSemigroups added.

## 0.7

- SgpInMulTab can be given different closure functions.

## 0.6 (2013-12-04)

- Alternative closure method added, further work on combining ideals, simplifications.

## 0.5 (2013-11-17)

- Lot of work on enumerating by parallel search for ideals.

## 0.4 (2013-11-03)

- MulTab now is an attribute storing object, so no more record references.

## 0.3 (2013-11-02)

- Adding invariants for both element and multiplication table level.

## 0.2 (2013-10-22)

- Adding test cases, checking against brute-force methods. Converting between the indicator set (bitlist) and the subsets of semigroups.

## 0.1 (2013-10-19)

- Working 1-extension method transferred, but poor package structure, no test cases yet.
