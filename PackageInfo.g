##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.86">
##  <!ENTITY COPYRIGHTYEARS "2013-2025">
##  <#/GAPDoc>

SetPackageInfo( rec(

PackageName := "SubSemi",

Subtitle := "Enumeration of subsemigroups",

Version := "0.86",

Date := "20/06/2025",

Persons := [
  rec(
    LastName      := "Egri-Nagy",
    FirstNames    := "Attila",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "attila@egri-nagy.hu",
    WWWHome       := "http://www.egri-nagy.hu",
    PostalAddress := Concatenation( [
                       "Akita International University",
                       "Yuwa, Akita-City 010-1292 Japan" ] ),
    Place         := "Akita",
    Institution   := "AIU"
      ),

  rec(
       LastName      := "East",
       FirstNames    := "James",
       IsAuthor      := true,
       IsMaintainer  := false,
       Email         := "J.East@westernsydney.edu.au",
       WWWHome       := "https://staff.cdms.westernsydney.edu.au/~james/",
       PostalAddress := Concatenation( ["Locked Bag 1797",
                                        "Penrith NSW 2751"] ),
       Place         := "Sydney",
       Institution   := "WSU"
      ),

  rec(
    LastName      := "Mitchell",
    FirstNames    := "James D.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "jdm3@st-and.ac.uk",
    WWWHome       := "https://www.st-andrews.ac.uk/mathematics-statistics/people/jdm3/",
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
SourceRepository := rec(
  Type := "git",
  URL := "https://github.com/gap-packages/subsemi"
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
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
 GAP := ">= 4.14.0",
 NeededOtherPackages := [ ["semigroups", ">=5.4.0"] ],
 SuggestedOtherPackages := [],
 ExternalConditions := [ ]
),

AvailabilityTest := ReturnTrue,

Autoload := false,

TestFile := "tst/testall.g",

Keywords := ["subsemigroup",
             "multiplication table"]
));
