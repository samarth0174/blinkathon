// To parse this JSON data, do
//
//     final gifts = giftsFromJson(jsonString);

import 'dart:convert';

Gifts giftsFromJson(String str) => Gifts.fromJson(json.decode(str));

String giftsToJson(Gifts data) => json.encode(data.toJson());

class Gifts {
    Gifts({
        this.d,
    });

    List<D> d;

    factory Gifts.fromJson(Map<String, dynamic> json) => Gifts(
        d: json["d"] == null ? null : List<D>.from(json["d"].map((x) => D.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "d": d == null ? null : List<dynamic>.from(d.map((x) => x.toJson())),
    };
}

class D {
    D({
        this.type,
        this.caption,
        this.captionLower,
        this.code,
        this.color,
        this.currency,
        this.data,
        this.desc,
        this.disclosures,
        this.discount,
        this.domain,
        this.fee,
        this.fontcolor,
        this.isVariable,
        this.iso,
        this.logo,
        this.maxRange,
        this.minRange,
        this.sendcolor,
        this.value,
    });

    String type;
    String caption;
    String captionLower;
    String code;
    String color;
    String currency;
    String data;
    String desc;
    String disclosures;
    double discount;
    String domain;
    String fee;
    String fontcolor;
    bool isVariable;
    String iso;
    String logo;
    int maxRange;
    int minRange;
    String sendcolor;
    String value;

    factory D.fromJson(Map<String, dynamic> json) => D(
        type: json["__type"] == null ? null : json["__type"],
        caption: json["caption"] == null ? null : json["caption"],
        captionLower: json["captionLower"] == null ? null : json["captionLower"],
        code: json["code"] == null ? null : json["code"],
        color: json["color"] == null ? null : json["color"],
        currency: json["currency"] == null ? null : json["currency"],
        data: json["data"] == null ? null : json["data"],
        desc: json["desc"] == null ? null : json["desc"],
        disclosures: json["disclosures"] == null ? null : json["disclosures"],
        discount: json["discount"] == null ? null : json["discount"].toDouble(),
        domain: json["domain"] == null ? null : json["domain"],
        fee: json["fee"] == null ? null : json["fee"],
        fontcolor: json["fontcolor"] == null ? null : json["fontcolor"],
        isVariable: json["is_variable"] == null ? null : json["is_variable"],
        iso: json["iso"] == null ? null : json["iso"],
        logo: json["logo"] == null ? null : json["logo"],
        maxRange: json["max_range"] == null ? null : json["max_range"],
        minRange: json["min_range"] == null ? null : json["min_range"],
        sendcolor: json["sendcolor"] == null ? null : json["sendcolor"],
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "__type": type == null ? null : type,
        "caption": caption == null ? null : caption,
        "captionLower": captionLower == null ? null : captionLower,
        "code": code == null ? null : code,
        "color": color == null ? null : color,
        "currency": currency == null ? null : currency,
        "data": data == null ? null : data,
        "desc": desc == null ? null : desc,
        "disclosures": disclosures == null ? null : disclosures,
        "discount": discount == null ? null : discount,
        "domain": domain == null ? null : domain,
        "fee": fee == null ? null : fee,
        "fontcolor": fontcolor == null ? null : fontcolor,
        "is_variable": isVariable == null ? null : isVariable,
        "iso": iso == null ? null : iso,
        "logo": logo == null ? null : logo,
        "max_range": maxRange == null ? null : maxRange,
        "min_range": minRange == null ? null : minRange,
        "sendcolor": sendcolor == null ? null : sendcolor,
        "value": value == null ? null : value,
    };
}
