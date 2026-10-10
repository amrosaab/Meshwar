import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../application/acc_bloc.dart';
import '../../../../domain/models/faq_model.dart';
import 'settings_document_content.dart';

class FaqDataListWidget extends StatelessWidget {
  const FaqDataListWidget(
      {super.key, required this.cont, required this.faqDataList});
  final BuildContext cont;
  final List<FaqData> faqDataList;
  @override
  Widget build(BuildContext context) {
    final bloc = cont.read<AccBloc>();
    return ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: faqDataList.length,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) => FaqAnswerCard(
              key: ValueKey(faqDataList[index].id),
              question: faqDataList[index].question,
              answer: faqDataList[index].answer,
              expanded: bloc.choosenFaqIndex == index,
              onTap: () => bloc.add(FaqOnTapEvent(selectedFaqIndex: index)),
            ));
  }
}
