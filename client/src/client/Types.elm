module Types exposing (..)

import Translations as T

type alias Model = 
    { config: Config
    , debounce : Bool
    , screenSize: ScreenSize
    , page: Page
    , previous: Maybe Page
    , data: Data
    }

type Msg 
    = SetScreenSize ScreenSize
    | SetSize Size
    | SetContrast Bool
    | SetReader Bool
    | SetLanguage T.Lang
    | SetPage Page
    | Back
    | SetGrade Int
    | SetLocation String
    | LocationDropdown (List (String, String))
    | SetCareer String
    | SecondaryLeft 
    | SecondaryRight

type alias Data =
    { grade: Int
    , location: String
    , career: String
    }

getGrade: Model -> Int
getGrade model = 
    model.data.grade

getLocation: Model -> String
getLocation model = 
    model.data.location

getCareer: Model -> String
getCareer model = 
    model.data.career

type alias ScreenSize = {width: Int, height: Int}

type Size = Normal | Large | Larger

type Page = Splash | Query | Explore | Secondary | PostSecondary | Career | Report | Menu | Login

type alias Config =
    { language : T.Lang
    , size: Size
    , contrast: Bool
    , reader: Bool 
    }

getLanguage: Model -> T.Lang
getLanguage model =
    model.config.language

getSize: Model -> Size
getSize model =
    model.config.size

getContrast: Model -> Bool
getContrast model =
    model.config.contrast

getReader: Model -> Bool
getReader model =
    model.config.reader

type alias Text =
    { english: String
    , french: String
    }

getText: Text -> Model -> String
getText text model =
    case getLanguage model of
        T.En ->
            text.english

        T.Fr ->
            text.french

type alias Course =
    { code: String
    , name: Text
    , prerequisites: List String
    }

