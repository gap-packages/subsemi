################################################################################
##
## SubSemi
##
## Functions for putting subsets, subsgps into separate files according to
## some classification.
##
## Copyright (C) 2015  Attila Egri-Nagy
##

# filename extensions and their meanings #######################################
# database in a textfile containing subsgps as encoded subsets, sgptags,
# short structure descriptions of automorphism groups and normalizers
BindGlobal("DB@", ".db");

# elements of a semigroup written out in order as it is used in MulTab
# for further reference in interpreting SGPS@ files
BindGlobal("ELTS@", ".elts");

# subsets (subgroups, subsemigroups), 6bit encoded
BindGlobal("SUBS@", ".subs");

DeclareGlobalFunction("FileSubsemigroups");
