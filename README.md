[![Build Status](https://travis-ci.org/gap-packages/subsemi.svg?branch=blist)](https://travis-ci.org/gap-packages/subsemi)
[![Code Coverage](https://codecov.io/github/gap-packages/subsemi/coverage.svg?branch=blist&token=)](https://codecov.io/gh/gap-packages/subsemi)
# SubSemi

GAP package for enumerating subsemigroups of semigroup, deciding isomorphisms
and constructing embeddings. The algorithms assume that the elements of the
semigroups can be fully calculated, therefore their applicability is limited
to relatively small semigroups.

The original motivation for developing the package was the computational
enumeration of transformation semigroups up to degree 4. Instructions for
recomputing those results can be found in the data/T4 folder. 

The code is highly experimental with no user documentation,
only inline comments. The algorithms are described on a
high level in the preprint 'On Enumerating Transformation Semigroups'
http://arxiv.org/abs/1403.0274

The enumeration was extended to other diagram semigroups, see the data/SMALLDEGREE folder and the preprint http://arxiv.org/abs/1502.07150 'Finite Diagram Semigroups: Extending the Computational Horizon'. 

## Installation

Just copying, or more conveniently cloning, the repository under GAP/pkg/.

Copyright (C) 2014 James East, Attila Egri-Nagy, James D. Mitchell

SubSemi is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License,
or (at your option) any later version.
