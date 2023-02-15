import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:toko_sayur/model/user_model.dart';
import 'package:toko_sayur/view_model/user_view_model.dart';

import '../../../../common/style/style.dart';
import '../../../admin/product/widgets/field_product.dart';
import '../../../widgets/button_widget.dart';

class ModalUpdateUserAddress extends StatefulWidget {
  final UserModel user;
  const ModalUpdateUserAddress({super.key, required this.user});

  @override
  State<ModalUpdateUserAddress> createState() => _ModalAddWorkspaceState();
}

class _ModalAddWorkspaceState extends State<ModalUpdateUserAddress> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _phoneController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.user.address;
    _phoneController.text = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    final focusField = FocusNode();

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          focusField.unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        },
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.r),
              topRight: Radius.circular(5.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              _closeButton(context),
              SizedBox(height: 8.h),
              _formAddWorkspace(),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24.r, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formAddWorkspace() {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldProduct(
                controller: _addressController,
                hintText: "Address",
                width: double.maxFinite,
                height: 55,
                onlyNumber: false),
            SizedBox(height: 8.h),
            FieldProduct(
                onlyNumber: true,
                controller: _phoneController,
                hintText: "Phone",
                width: double.maxFinite,
                height: 55),
            SizedBox(height: 16.h),
            Consumer<UserViewModel>(
              builder: (context, user, _) => ButtonWidget(
                height: 45,
                width: double.maxFinite,
                text: "Update Product Category",
                onTap: () async {
                  if (_addressController.text.isEmpty ||
                      _phoneController.text.isEmpty) {
                    return Fluttertoast.showToast(
                        msg: "Field Can't Be Empty", textColor: Colors.white);
                  } else {
                    await user
                        .updateUser(
                            UserModel(
                                image: widget.user.image,
                                fullName: widget.user.fullName,
                                email: widget.user.email,
                                address: _addressController.text,
                                phone: _phoneController.text),
                            widget.user.id!)
                        .then(
                          (_) => Navigator.pop(context),
                        );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
