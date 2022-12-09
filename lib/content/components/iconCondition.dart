import 'package:PocketFlow/design/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

iconCondition(category) {
  if (category == 'Entertainment') {
    return const FaIcon(
      FontAwesomeIcons.gamepad,
      size: 35,
      color: mainDesignColor,
    );
  } else if (category == 'Social & Lifestyle') {
    return const Icon(
      Icons.people_rounded,
      size: 37,
      color: mainDesignColor,
    );
  } else if (category == 'Beauty & Health') {
    return const Icon(
      FontAwesomeIcons.heartPulse,
      size: 37,
      color: mainDesignColor,
    );
  } else if (category == 'Work & Education') {
    return const Icon(
      FontAwesomeIcons.book,
      size: 35,
      color: mainDesignColor,
    );
  } else if (category == 'Others') {
    return const Icon(
      Icons.document_scanner_rounded,
      size: 37,
      color: mainDesignColor,
    );
  }
}

iconConditionIncome(transactionType) {
  if (transactionType == 'Income') {
    return const Icon(
      Icons.trending_up_rounded,
      size: 37,
      color: mainDesignColor,
    );
  } else if (transactionType == 'Expense') {
    return const Icon(
      Icons.trending_down_rounded,
      size: 37,
      color: mainDesignColor,
    );
  }
}
