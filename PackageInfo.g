##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.13">
##  <!ENTITY COPYRIGHTYEARS "2013-2014">
##  <#/GAPDoc>

SetPackageInfo( rec(

PackageName := "SubSemi",

Subtitle := "Enumeration of subsemigroups",

Version := "0.14",

Date := "13/01/2014",

ArchiveURL := "https://bitbucket.org/dersu/subsemi",

ArchiveFormats := ".tar.gz",

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

README_URL := "https://bitbucket.org/dersu/subsemi",

PackageInfoURL := "https://bitbucket.org/dersu/subsemi",

AbstractHTML := "<span class=\"pkgname\">SubSemi</span> is  a <span class=\
                   \"pkgname\">GAP</span> \
                   for enumerating subsemigroups.",

PackageWWWHome := "https://bitbucket.org/dersu/subsemi",

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
 GAP := ">= 4.6",
 NeededOtherPackages := [["GAPDoc", ">=1.5"],
                   ["semigroups", ">=1.4"],
                   ["sgpdec", ">=0.7"],
                   ["dust", ">=0.1.16"]
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
