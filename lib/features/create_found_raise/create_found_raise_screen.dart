// ignore_for_file: use_build_context_synchronously

import 'package:app/common/common_values.dart';
import 'package:app/common/user_model.dart';
import 'package:app/common/widgets/user_search_widget.dart';
import 'package:app/features/create_found_raise/found_raise_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

final _formKey = GlobalKey<FormBuilderState>();

@RoutePage()
class CreateFoundRaiseScreen extends StatefulWidget {
  const CreateFoundRaiseScreen({super.key});

  @override
  State<CreateFoundRaiseScreen> createState() => _CreateFoundRaiseScreenState();
}

class _CreateFoundRaiseScreenState extends State<CreateFoundRaiseScreen> {
  final recipientNotifier = ValueNotifier<UserModel?>(null);

  Future<void> createFoundRaise() async {
    _formKey.currentState?.saveAndValidate(focusOnInvalid: false);

    if (recipientNotifier.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleziona un destinatario'),
        ),
      );
      return;
    }
    if (_formKey.currentState?.isValid ?? false) {
      try {
        await FirebaseFirestore.instance.collection('found_raise').add(
              FoundRaiseModel(
                id: const Uuid().v4(),
                creatorEmail: FirebaseAuth.instance.currentUser!.email!,
                recipientEmail: recipientNotifier.value!.email,
                goal: num.parse(
                  _formKey.currentState?.value['goal'] as String,
                ),
                fee: num.parse(
                  _formKey.currentState?.value['fee'] as String,
                ),
                attendeesEmail: [],
                creationDate: DateTime.now().toIso8601String(),
              ).toJson(),
            );

        await context.router.maybePop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Compila tutti i campi',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: kIsWeb
            ? null
            : AppBar(
                title: const Text('Nuova Raccolta'),
              ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: context.appWidth(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: recipientNotifier,
                      builder: (context, model, child) {
                        if (model == null) {
                          return UserSearchWidget(
                            onUserSelected: (value) {
                              recipientNotifier.value = value;
                            },
                          );
                        } else {
                          return FormBuilderTextField(
                            name: 'recipient',
                            decoration: InputDecoration(
                              labelText:
                                  // ignore: lines_longer_than_80_chars
                                  '${recipientNotifier.value?.name} - ${recipientNotifier.value?.email}',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(8),
                            ),
                            enabled: false,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Scegli un destinatario';
                              }
                              return null;
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox.square(dimension: 16),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: 'goal',
                            decoration: const InputDecoration(
                              labelText: 'Quanto vorresti raccogliere?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                decimalDigits: 2,
                                enableNegative: false,
                                locale: Platform.localeName,
                              ),
                            ],
                            valueTransformer: (value) {
                              return value
                                  ?.replaceAll(RegExp('[a-zA-Z]'), '')
                                  .replaceAll(',', '.')
                                  .trim();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Inserisci un'importo";
                              }
                              return null;
                            },
                          ),
                          const SizedBox.square(dimension: 16),
                          FormBuilderTextField(
                            name: 'fee',
                            decoration: const InputDecoration(
                              labelText: 'Quota consigliata',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                decimalDigits: 2,
                                enableNegative: false,
                                locale: Platform.localeName,
                              ),
                            ],
                            valueTransformer: (value) {
                              return value
                                  ?.replaceAll(RegExp('[a-zA-Z]'), '')
                                  .replaceAll(',', '.')
                                  .trim();
                            },
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "Inserisci un'importo";
                              }
                              return null;
                            },
                          ),
                          const SizedBox.square(dimension: 16),
                          FormBuilderTextField(
                            name: 'dueDate',
                            decoration: InputDecoration(
                              labelText: 'Limite di partecipazione',
                              hintText:
                                  DateFormat.yMd(Platform.localeName).format(
                                DateTime.now(),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(8),
                            ),
                            inputFormatters: [
                              DateInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox.square(dimension: 16),
                          FormBuilderTextField(
                            name: 'birthday',
                            decoration: InputDecoration(
                              labelText: 'Compleanno',
                              hintText:
                                  DateFormat.yMd(Platform.localeName).format(
                                DateTime.now(),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.all(8),
                            ),
                            inputFormatters: [
                              DateInputFormatter(),
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox.square(dimension: 16),
                          OutlinedButton(
                            onPressed: createFoundRaise,
                            child: const Text('Crea raccolta'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
