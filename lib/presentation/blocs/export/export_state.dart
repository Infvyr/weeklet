import 'package:equatable/equatable.dart';

/// Discriminator so each screen's BlocListener only reacts to its own export.
enum ExportType { expenses, income }

sealed class ExportState extends Equatable {
  const ExportState();

  @override
  List<Object?> get props => [];
}

final class ExportInitial extends ExportState {
  const ExportInitial();
}

final class ExportInProgress extends ExportState {
  const ExportInProgress();
}

final class ExportSuccess extends ExportState {
  const ExportSuccess({
    required this.filePath,
    required this.subject,
    required this.exportType,
  });

  final String filePath;
  final String subject;
  final ExportType exportType;

  @override
  List<Object?> get props => [filePath, subject, exportType];
}

final class ExportFailure extends ExportState {
  const ExportFailure(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
