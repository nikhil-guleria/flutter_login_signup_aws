import 'package:flutter_aws_login/Utils/customgallery/delegate/badge_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/checkbox_builder_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/loading_delegate.dart';
import 'package:flutter_aws_login/Utils/customgallery/delegate/sort_delegate.dart';
import 'package:flutter/material.dart';





class Options {
  final int rowCount;

  final int maxSelected;

  final double padding;

  final double itemRadio;

  final Color themeColor;

  final Color dividerColor;

  final Color textColor;

  final Color disableColor;

  final int thumbSize;

  final SortDelegate sortDelegate;

  final CheckBoxBuilderDelegate checkBoxBuilderDelegate;

  final LoadingDelegate loadingDelegate;

  final BadgeDelegate badgeDelegate;

  final PickType pickType;

  const Options({
    this.rowCount,
    this.maxSelected,
    this.padding,
    this.itemRadio,
    this.themeColor,
    this.dividerColor,
    this.textColor,
    this.disableColor,
    this.thumbSize,
    this.sortDelegate,
    this.checkBoxBuilderDelegate,
    this.loadingDelegate,
    this.badgeDelegate,
    this.pickType,
  });
}

enum PickType {
  all,
  onlyImage,
  onlyVideo,
}
