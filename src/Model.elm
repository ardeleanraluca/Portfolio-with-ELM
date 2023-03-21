module Model exposing (..)

import Html exposing (b, div, p, text)
import Model.Date as Date
import Model.Event as Event exposing (Event)
import Model.Event.Category exposing (EventCategory(..), SelectedEventCategories, allSelected)
import Model.Interval as Interval
import Model.PersonalDetails exposing (DetailWithName, PersonalDetails)
import Model.Repo exposing (Repo)


type alias Model =
    { personalDetails : PersonalDetails
    , events : List Event
    , selectedEventCategories : SelectedEventCategories
    , repos : List Repo
    }



-- academicEvents : List Event


academicEvents =
    [ { title = "Technical University of Cluj-Napoca"
      , interval = Interval.open (Date.full 2020 Date.Oct)
      , description = p [] [ text "Computer Science" ]
      , category = Academic
      , url = Just "https://ac.utcluj.ro/acasa.html"
      , tags = []
      , important = True
      }
    , { title = "Studied at the 'Simion Bărnuțiu' National College"
      , interval = Interval.withDurationYears (Date.onlyYear 2016) 4
      , description = div [] [ text "Main subjects: mathematics, informatics" ]
      , category = Academic
      , url = Nothing
      , tags = []
      , important = False
      }
    ]


workEvents : List Event
workEvents =
    [ { title = "Full Stack Developer Intern"
      , interval = Interval.withDurationMonths 2022 Date.Jul 3
      , description = text "Web development"
      , category = Work
      , url = Nothing
      , tags = [ "Full-Stack", "Java Spring", "Angular" ]
      , important = False
      }
    ]


projectEvens : List Event
projectEvens =
    [ { title = "Computer Vision Camp"
      , interval = Interval.withDurationMonths 2021 Date.Oct 2
      , description = text "Working on an app that estimates and predicts the probability of car accidents "
      , category = Project
      , url = Just "https://www.facebook.com/photo/?fbid=414421126800690&set=a.103203761255763"
      , tags = []
      , important = False
      }
    ]


personalDetails : PersonalDetails
personalDetails =
    { name = "Ardelean Raluca"
    , intro = "~ Whatever you are, be a good one ~"
    , contacts =
        [ DetailWithName "email" "ardelean.raluca.3@yahoo.com"
        , DetailWithName "phone" "0751682482"
        ]
    , socials =
        [ DetailWithName "Github" "https://github.com/ardeleanraluca"
        , DetailWithName "LinkedIn" "https://www.linkedin.com/in/raluca-ardelean-12b178207/"
        ]
    }


initModel : Model
initModel =
    { personalDetails = personalDetails
    , events = Event.sortByInterval <| academicEvents ++ workEvents ++ projectEvens
    , selectedEventCategories = allSelected
    , repos = []
    }
