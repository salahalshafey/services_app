import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services_app/src/core/util/widgets/image_container.dart';

import '../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../core/util/builders/custom_snack_bar.dart';
import '../../../../core/util/builders/image_picker.dart';

import '../../../../core/util/functions/string_manipulations_and_search.dart';
import '../../../account/presentation/providers/account.dart';
import '../../../services_givers/presentation/providers/services_givers.dart';

import '../../domain/entities/order.dart';
import '../providers/orders.dart';

class RequestServiceForm extends StatefulWidget {
  const RequestServiceForm(this.serviceGiverId, this.serviceName, {Key? key})
      : super(key: key);
  final String serviceGiverId;
  final String serviceName;
  @override
  State<RequestServiceForm> createState() => _RequestServiceFormState();
}

class _RequestServiceFormState extends State<RequestServiceForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  var _textDirection = getDirectionalityOf("");

  XFile? _image;
  var _editedorder = Order(
    id: '',
    serviceGiverId: '',
    serviceGiverName: '',
    serviceGiverImage: '',
    serviceGiverPhoneNumber: '',
    userId: '',
    userName: '',
    userImage: '',
    userPhoneNumber: '',
    serviceName: '',
    cost: 0,
    quantity: 0,
    description: '',
    image: '',
    date: DateTime.now(),
    status: 'not finished',
  );
  var _isLoading = false;

  void _isLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    ///////// Validate that all Fields are gathered /////////
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_image == null) {
      showCustomAlretDialog(
        context: context,
        title: 'Field Missing',
        titleColor: Colors.red,
        content: 'Please Pick An Image',
      );
      return;
    }

    ///////// Save the data from textFields And serviceGiver And current user /////////
    _formKey.currentState!.save();
    final serviceGiver = Provider.of<ServicesGivers>(context, listen: false)
        .getServiceGiverById(widget.serviceGiverId);
    final currentUser = Provider.of<Account>(context, listen: false);

    _editedorder = _editedorder.copyWith(
      serviceGiverId: serviceGiver.id,
      serviceGiverName: serviceGiver.name,
      serviceGiverImage: serviceGiver.image,
      serviceGiverPhoneNumber: serviceGiver.phoneNumber,
      userId: currentUser.id,
      userName: currentUser.name,
      userImage: currentUser.image,
      userPhoneNumber: currentUser.phoneNumber,
      serviceName: widget.serviceName,
      cost: serviceGiver.cost,
      date: DateTime.now(),
    );

    ///////// Add the order And handle the errors and loading /////////
    final orders = Provider.of<Orders>(context, listen: false);
    try {
      _isLoadingState(true);
      final savedOrderId =
          await orders.addOrder(_editedorder, File(_image!.path));

      _editedorder = _editedorder.copyWith(id: savedOrderId);
    } catch (error) {
      _isLoadingState(false);
      showCustomAlretDialog(
        context: context,
        title: 'ERROR',
        titleColor: Colors.red,
        content: '$error',
      );
      return;
    }

    ///////////// if There is no errors go to current order screen /////////////
    Navigator.of(context).pop();
    Navigator.of(context).pop();

    ///////// show Request Saved message And handle potential Errors ///////////
    showMySnackBar(
      context: context,
      content: 'Request Saved',
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () => orders.removeOrderById(_editedorder.id)),
    );
  }

  void _pickImage() async {
    myImagePicker(context).then((pickedImage) {
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_descriptionFocusNode),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Quantity';
              }
              int? quantity = int.tryParse(value);
              if (quantity == null) {
                return 'Please enter valid number';
              }
              return null;
            },
            onSaved: (value) {
              _editedorder = _editedorder.copyWith(quantity: int.parse(value!));
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            focusNode: _descriptionFocusNode,
            textDirection: _textDirection,
            controller: descriptionController,
            onChanged: (description) {
              setState(() {
                _textDirection = getDirectionalityOf(description);
              });
            },
            validator: (value) {
              value ??= '';
              if (value.isEmpty) {
                return 'Please enter a description.';
              }
              if (value.length < 10) {
                return 'description should be at least 10 characters long.';
              }
              return null;
            },
            onSaved: (value) {
              _editedorder = _editedorder.copyWith(description: value);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text(
              'PIC IMAG',
            ),
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  minimumSize: const WidgetStatePropertyAll(Size(150, 40)),
                ),
          ),
          const SizedBox(height: 10),
          Align(
            child: _image == null
                ? const SizedBox(height: 200)
                : ImageContainer(
                    image: _image!.path,
                    imageSource: From.file,
                    radius: 100,
                    showImageScreen: true,
                    showHighlight: true,
                    imageTitle: 'Image of the problem',
                    imageCaption: descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                  ),
          ),
          // this for the image
          const SizedBox(height: 10),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text(
                    'REQUEST',
                  ),
                  style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                        minimumSize: const WidgetStatePropertyAll<Size>(
                            Size(double.infinity, 40)),
                      ),
                ),
        ],
      ),
    );
  }
}
