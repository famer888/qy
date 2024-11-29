class FeedBackMessageProblemModel {
  final String? problem;
  final String? reply;

  FeedBackMessageProblemModel({
    this.problem,
    this.reply,
  });

  factory FeedBackMessageProblemModel.fromJson(Map<String, dynamic> json) =>
      FeedBackMessageProblemModel(
        problem: json['problem'],
        reply: json['reply'],
      );
}
