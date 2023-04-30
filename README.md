# elm-bem

Utilities for following BEM ([Block-Element-Modifier](https://getbem.com/naming))
conventions in CSS classes.

This library builds on work done in 
[renanpvaz/elm-bem](https://package.elm-lang.org/packages/renanpvaz/elm-bem/latest) 
with a different API.

It supports both "flag" style and "key-value" style modifiers on blocks and
elements.


## Example

```elm
import Html.Bem as Bem

view : String -> { sticky : Bool, title : String, bodyData : BodyData } -> Html msg
view blockName model =
    let
        block =
            Bem.init blockName

        headerEl =
            block.element "header"

        bodyEl =
            block.element "body"
    in
    div
        [ block |> Bem.block ]
        [ header
            [ headerEl |> Bem.elementIf "sticky" model.sticky ]  
            [ h1 [] [ text model.title ] ]
        , div
            [ bodyEl |> Bem.elementOf "type" model.bodyData.bodyType ]
            [ viewBody block model.bodyData ]
        ]

viewBody : Bem.Block -> BodyData -> Html msg
viewBody block bodyData =
    -- render sub-elements tied to the top-level Bem.Block

```

Then calling 

```elm
view 
    "thing" 
    { sticky: True, title: "Thing", bodyData = { bodyType = "article", ... } }
```

results in

```html
<div class="thing">
    <header class="thing__header thing__header--sticky">
        <h1>Thing</h1>
    </header>
    <div class="thing__body thing__body--type-article">
        ...
    </div>
</div>
```

## Installing

Install in the root of your project

```shell
$ elm install ericgj/elm-bem
```

and import in your modules like

```elm
import Html.Bem
```
