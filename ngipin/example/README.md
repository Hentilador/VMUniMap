# Teeth Selector

A simple dental chart showing teeth that can be selected/unselected like a set of checkboxes. It can show primary and/or permanent teeth. It also can select one or multiple teeth.

## Getting Started

Instal the package using `flutter pub add teeth_selector`

Import it:

```dart
import 'package:teeth_selector/teeth_selector.dart';
```

## Usage

```dart
TeethSelector(
  // Required: a callback to be executed when the user selects/unselects a tooth
  onChange: (selected) => print(selected),

  // showing permanent teeth
  // default: true
  showPermanent: true,
  
  // showing primary teeth
  // default: true
  showPrimary: true,

  // A notation for each tooth
  // provide a function that when given an ISO notation string
  // would convert to other notation you may want
  // default: null (ISO notation on tooltips)
  notation: (isoString) => "ISO: $isoString",

  // Whether the user can select multiple teeth
  // default: false
  multiSelect: true,

  // The color that denotes that the tooth is selected
  // default: Colors.blue
  selectedColor: Colors.yellow,

  // Default color of the teeth that are not selected
  // default: Colors.white
  unselectedColor: Colors.red,

  // Color of the tooltip
  // default: Colors.black
  tooltipColor: Colors.purple,

  // Which teeth are initially selected
  // you must provide a list of ISO notations
  // default: []
  initiallySelected: ["11", "47", "48"],

  // colorize some of the teeth
  // default: {}
  colorize: {
    "11": Colors.purple,
  },

  // Colorize the stroke of some teeth
  // default: {}
  strokeColorized: {
    "11": Colors.purple,
  },

  // Default stroke color
  // default: Colors.transparent
  defaultStrokeColor: Colors.red,

  // Stroke width of specific teeth
  // default: {}
  strokeWidth: {
    "11": 10.0,
    "12": 10.0,
  },

  // Stroke width of all other teeth
  // default: 1.0
  defaultStrokeWidth: 10.0,

  // Text denotes the left side of the mouth
  // default: "Left"
  leftString: "Left",

  // Text denotes the right side of the mouth
  // default: "Right"
  rightString: "جهة اليمين",

  // Text style for the two strings above
  // default: null
  textStyle: TextStyle(
    fontSize: 16,
  ),

  // Text style for the tooltip
  // default: null
  tooltipTextStyle: TextStyle(
    fontSize: 16,
  ),
)
```

![Basic teeth selector](https://media.giphy.com/media/X3MyQC4P8XGteUM7FL/giphy.gif)
![Teeth selector with some options](https://media.giphy.com/media/ZZYmDrTDsnnoKE8hTi/giphy.gif)