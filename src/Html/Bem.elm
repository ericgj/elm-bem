module Html.Bem exposing
    ( Block
    , Element
    , block
    , blockIf
    , blockList
    , blockMod
    , blockOf
    , element
    , elementIf
    , elementList
    , elementMod
    , elementName
    , elementNameMod
    , elementNameOf
    , elementOf
    , elementOfList
    , init
    )

{-| Utilities for building CSS class names based on [BEM conventions]().


# Creating

@docs init

# Unmodified block and element classes

@docs block, element

# Flag modified block and element classes

@docs blockMod, elementMod, blockIf, elementIf, blockList, elementList

# Key-value modified block and element classes

@docs blockOf, elementOf, blockOfList, elementOfList

# Raw class strings

@docs elementName, elementNameMod, elementNameOf

# Types

@docs Block, Element

-}

import Html exposing (Attribute)
import Html.Attributes exposing (class, classList)


{-| Type for building block classes, and constructing elements of blocks. 
-}
type alias Block =
    { name : String
    , element : String -> Element
    }

{-| Type for building element classes.
-}
type alias Element =
    { block : String
    , name : String
    }

{-| Construct a top-level [Block](#Block) with given name.

Note an [Element](#Element) can only be constructed through the `.element` of
a Block like this:

    let
        block = 
            Bem.init "my-block"
    in
    block.element "my-element"
-}
init : String -> Block
init b =
    { name = b
    , element = Element b
    }

{-| Element class string, e.g. "my-block__my-element"
-}
elementName : Element -> String
elementName e =
    joinElement e.block e.name


{-| Element class string with given flag modifier, e.g. 
"my-block__my-element--flag"
-}
elementNameMod : Element -> String -> String
elementNameMod e m =
    joinElementMod e.block e.name m


{-| Element class string with given key-value modifier, e.g. 
"my-block__my-element--key-value"
-}
elementNameOf : Element -> String -> String -> String
elementNameOf e k v =
    joinElementOf e.block e.name k v


{-| Class attribute for unmodified block

    Bem.init "my-block" |> Bem.block   
        -- class "my-block"
-}
block : Block -> Attribute a
block b =
    class b.name


{-| Class attribute for "key-value" modified block

    Bem.init "my-block" |> Bem.blockOf "type" "foo"  
        -- class "my-block my-block--type-foo"
-}
blockOf : String -> String -> Block -> Attribute a
blockOf k v b =
    classList
        [ ( b.name, True )
        , ( joinBlockOf b.name k v, True )
        ]


{-| Class attribute for "flag" modified block

    Bem.init "my-block" |> Bem.blockMod "flagged"  
        -- class "my-block my-block--flagged"
-}
blockMod : String -> Block -> Attribute a
blockMod m b =
    blockIf m True b


{-| Class attribute for "flag" modified block, based on given boolean flag

    Bem.init "my-block" |> Bem.blockIf "flagged" isFlagged  
        -- class "my-block my-block--flagged"  (if isFlagged is True)
        -- class "my-block"  (if isFlagged is False)
-}
blockIf : String -> Bool -> Block -> Attribute a
blockIf m incl b =
   classList 
       [ ( b.name, True )
       , ( joinBlockMod b.name m, incl )
       ]

{-| Class attribute for "flag" modified block, with multiple flags applied.
Similar to Html.Attributes.classList for flag-modified blocks.

    Bem.init "my-block" 
        |> Bem.blockList [("flagged", isFlagged), ("editable", isEditable)]
-}
blockList : List ( String, Bool ) -> Block -> Attribute a
blockList list b =
    classList <|
        ( b.name, True )
            :: (list |> List.map (\( m, incl ) -> ( joinBlockMod b.name m, incl )))


{-| Class attribute for "key-value" modified block, with multiple key-value
pairs applied.

    Bem.init "my-block" 
        |> Bem.blockOfList [( "type", "foo" ), ( "status", "open" ) ]   
-}
blockOfList : List ( String, String ) -> Block -> Attribute a
blockOfList list b =
    classList <|
        ( b.name, True )
            :: (list |> List.map (\( k, v ) -> ( joinBlockOf b.name k v, True )))


{-| Class attribute for unmodified element

    Bem.init "my-block" |> .element "my-element" |> Bem.element
        -- class "my-block__my-element"
-}
element : Element -> Attribute a
element e =
    class <| joinElement e.block e.name


{-| Class attribute for "key-value" modified element

    Bem.init "my-block" |> .element "my-element" |> Bem.elementOf "type" "foo"  
        -- class "my-block__my-element my-block__my-element--type-foo"
-}
elementOf : String -> String -> Element -> Attribute a
elementOf k v e =
    classList
        [ ( joinElement e.block e.name, True )
        , ( joinElementOf e.block e.name k v, True )
        ]


{-| Class attribute for "flag" modified element

    Bem.init "my-block" |> .element "my-element" |> Bem.elementMod "flagged"  
        -- class "my-block__my-element my-block__my-element--flagged"
-}
elementMod : String -> Element -> Attribute a
elementMod m e =
    elementIf m True e


{-| Class attribute for "flag" modified element, based on given boolean flag

    Bem.init "my-block" |> .element "my-element" |> Bem.elementIf "flagged" isFlagged  
        -- class "my-block__my-element my-block__my-element--flagged"  (if isFlagged is True)
        -- class "my-block__my-element"  (if isFlagged is False)
-}
elementIf : String -> Bool -> Element -> Attribute a
elementIf m incl e =
    classList
        [ ( joinElement e.block e.name, True )
        , ( joinElementMod e.block e.name m, incl )
        ]


{-| Class attribute for "flag" modified element, with multiple flags applied.
Similar to Html.Attributes.classList for flag-modified elements.

    Bem.init "my-block" 
        |> .element "my-element"
        |> Bem.elementList [("flagged", isFlagged), ("editable", isEditable)]
-}
elementList : List ( String, Bool ) -> Element -> Attribute a
elementList list e =
    classList <|
        ( joinElement e.block e.name, True )
            :: (list |> List.map (\( m, incl ) -> ( joinElementMod e.block e.name m, incl )))


{-| Class attribute for "key-value" modified element, with multiple key-value
pairs applied.

    Bem.init "my-block" 
        |> .element "my-element" 
        |> Bem.elementOfList [( "type", "foo" ), ( "status", "open" ) ]   
-}
elementOfList : List ( String, String ) -> Element -> Attribute a
elementOfList list e =
    classList <|
        ( joinElement e.block e.name, True )
            :: (list |> List.map (\( k, v ) -> ( joinElementOf e.block e.name k v, True )))


joinBlockOf : String -> String -> String -> String
joinBlockOf b k v =
    b ++ "--" ++ k ++ "-" ++ v


joinBlockMod : String -> String -> String
joinBlockMod b m =
    b ++ "--" ++ m


joinElement : String -> String -> String
joinElement b e =
    b ++ "__" ++ e


joinElementOf : String -> String -> String -> String -> String
joinElementOf b e k v =
    b ++ "__" ++ e ++ "--" ++ k ++ "-" ++ v


joinElementMod : String -> String -> String -> String
joinElementMod b e m =
    b ++ "__" ++ e ++ "--" ++ m
