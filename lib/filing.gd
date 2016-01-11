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

DeclareGlobalFunction("FileSubsemigroups");
