##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.82">
##  <!ENTITY COPYRIGHTYEARS "2013-2016">
##  <#/GAPDoc>

SetPackageInfo( rec(

PackageName := "SubSemi",

Subtitle := "Enumeration of subsemigroups",

Version := "0.82",

Date := "20/07/2016",

Persons := [
  rec(
    LastName      := "Egri-Nagy",
    FirstNames    := "Attila",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "attila@egri-nagy.hu",
    WWWHome       := "http://www.egri-nagy.hu",
    PostalAddress := Concatenation( [
                       "University of Hertfordshire\n",
                       "STRI\n",
                       "College Lane\n",
                       "AL10 9AB\n",
                       "United Kingdom" ] ),
    Place         := "Hatfield, Herts",
    Institution   := "UH"
  ),
  rec(
    LastName      := "Mitchell",
    FirstNames    := "J. D.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "jdm3@st-and.ac.uk",
    WWWHome       := "http://tinyurl.com/jdmitchell",
    PostalAddress := Concatenation( [
                       "Mathematical Institute,",
                       " North Haugh,", " St Andrews,", " Fife,", " KY16 9SS,",
                       " Scotland"] ),
    Place         := "St Andrews",
    Institution   := "University of St Andrews"
  )
],

Status := "dev",

PackageWWWHome := "http://gap-packages.github.io/subsemi/",
README_URL     := Concatenation(~.PackageWWWHome, "README.md"),
PackageInfoURL := Concatenation(~.PackageWWWHome, "PackageInfo.g"),
ArchiveURL     := Concatenation("https://github.com/gap-packages/subsemi/",
                   "releases/download/v", ~.Version,
                   "/subsemi-", ~.Version),
                   ArchiveFormats := ".tar.gz .tar.bz2",

AbstractHTML := "<span class=\"pkgname\">SubSemi</span> is  a <span class=\
                   \"pkgname\">GAP</span> \
                   for enumerating subsemigroups.",

PackageDoc := rec(
  BookName  := "SubSemi",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Subsemigroup Enumeration",
  Autoload  := true
),

Dependencies := rec(
 GAP := ">= 4.8.2",
 NeededOtherPackages := [["GAPDoc", ">=1.5"],
                   ["semigroups", ">=2.7.2"],
                   ["sgpdec", ">=0.7.33"]
                   ],
 SuggestedOtherPackages := [],
 ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "tst/testinstall.tst",

Keywords := ["subsemigroup",
             "multiplication table"]
));
