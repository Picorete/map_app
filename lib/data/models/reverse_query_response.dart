// To parse this JSON data, do
//
//     final reverseQueryResponse = reverseQueryResponseFromJson(jsonString);

import 'dart:convert';

ReverseQueryResponse reverseQueryResponseFromJson(String str) =>
    ReverseQueryResponse.fromJson(json.decode(str));

String reverseQueryResponseToJson(ReverseQueryResponse data) =>
    json.encode(data.toJson());

class ReverseQueryResponse {
  ReverseQueryResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String type;
  List<double> query;
  List<Feature> features;
  String attribution;

  factory ReverseQueryResponse.fromJson(Map<String, dynamic> json) =>
      ReverseQueryResponse(
        type: json["type"],
        query: List<double>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.languageEs,
    this.placeNameEs,
    this.text,
    this.language,
    this.placeName,
    this.bbox,
    this.center,
    this.geometry,
    this.context,
    this.matchingText,
    this.matchingPlaceName,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String textEs;
  Language languageEs;
  String placeNameEs;
  String text;
  Language language;
  String placeName;
  List<double> bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;
  String matchingText;
  String matchingPlaceName;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: json["language_es"] == null
            ? null
            : languageValues.map[json["language_es"]],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: json["language"] == null
            ? null
            : languageValues.map[json["language"]],
        placeName: json["place_name"],
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        matchingText:
            json["matching_text"] == null ? null : json["matching_text"],
        matchingPlaceName: json["matching_place_name"] == null
            ? null
            : json["matching_place_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "language_es":
            languageEs == null ? null : languageValues.reverse[languageEs],
        "place_name_es": placeNameEs,
        "text": text,
        "language": language == null ? null : languageValues.reverse[language],
        "place_name": placeName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox.map((x) => x)),
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
        "matching_text": matchingText == null ? null : matchingText,
        "matching_place_name":
            matchingPlaceName == null ? null : matchingPlaceName,
      };
}

class Context {
  Context({
    this.id,
    this.wikidata,
    this.shortCode,
    this.textEs,
    this.languageEs,
    this.text,
    this.language,
  });

  Id id;
  Wikidata wikidata;
  String shortCode;
  Text textEs;
  Language languageEs;
  Text text;
  Language language;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: idValues.map[json["id"]],
        wikidata: wikidataValues.map[json["wikidata"]],
        shortCode: json["short_code"] == null ? null : json["short_code"],
        textEs: textValues.map[json["text_es"]],
        languageEs: languageValues.map[json["language_es"]],
        text: textValues.map[json["text"]],
        language: languageValues.map[json["language"]],
      );

  Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "wikidata": wikidataValues.reverse[wikidata],
        "short_code": shortCode == null ? null : shortCode,
        "text_es": textValues.reverse[textEs],
        "language_es": languageValues.reverse[languageEs],
        "text": textValues.reverse[text],
        "language": languageValues.reverse[language],
      };
}

enum Id {
  COUNTRY_8950424814360550,
  REGION_16267835172619380,
  PLACE_14030488380533860
}

final idValues = EnumValues({
  "country.8950424814360550": Id.COUNTRY_8950424814360550,
  "place.14030488380533860": Id.PLACE_14030488380533860,
  "region.16267835172619380": Id.REGION_16267835172619380
});

enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

enum Text { VENEZUELA, ZULIA, MARACAIBO }

final textValues = EnumValues({
  "Maracaibo": Text.MARACAIBO,
  "Venezuela": Text.VENEZUELA,
  "Zulia": Text.ZULIA
});

enum Wikidata { Q717, Q43269, Q171632 }

final wikidataValues = EnumValues({
  "Q171632": Wikidata.Q171632,
  "Q43269": Wikidata.Q43269,
  "Q717": Wikidata.Q717
});

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.wikidata,
    this.shortCode,
    this.foursquare,
    this.landmark,
    this.address,
    this.category,
  });

  String wikidata;
  String shortCode;
  String foursquare;
  bool landmark;
  String address;
  String category;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
        foursquare: json["foursquare"] == null ? null : json["foursquare"],
        landmark: json["landmark"] == null ? null : json["landmark"],
        address: json["address"] == null ? null : json["address"],
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
        "foursquare": foursquare == null ? null : foursquare,
        "landmark": landmark == null ? null : landmark,
        "address": address == null ? null : address,
        "category": category == null ? null : category,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
