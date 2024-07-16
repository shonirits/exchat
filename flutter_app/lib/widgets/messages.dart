import 'package:cached_network_image/cached_network_image.dart';
import 'package:exchat/helpers/common.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/config.dart';
import '../helpers/colors.dart';
import '../../main.dart';
import '../helpers/user.dart';
import '../models/hive.dart';
import 'package:widget_zoom/widget_zoom.dart';

//card to represent a single user in home screen
class MessagesCard extends StatefulWidget {
  final id;
  final message;
  final selfInfo;

  const MessagesCard({super.key, required int this.id, required this.message, this.selfInfo});

  @override
  State<MessagesCard> createState() => _MessagesCardState();
}

class _MessagesCardState extends State<MessagesCard> {

 var _genderDP = User.userGenderDP('Unknown');
 late final EditableTextContextMenuBuilder? contextMenuBuilder;

  @override
  Widget build(BuildContext context) {

    final int _id = widget.id;
    final _message= widget.message;
    final _selfInfo = widget.selfInfo;

    bool isMe = _selfInfo?.userId == _message.userId;

    return isMe ? _myMessage() : _recipientMessage();
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (!await launchUrl(Uri.parse(link.url))) {
      throw Exception('Could not launch ${link.url}');
    }
  }


  Widget _recipientMessage() {

    final int _id = widget.id;
    final _message = widget.message;
    bool _isUserExist = false;
    Color _statusColor = senaryTextColor;
    var _recipient;
    var nickname = '';

    final userId =_message.userId;

    final usersBox = UsersBox.getData();  

    final isUserExist = usersBox.values.where((elementUser) => elementUser.userId == userId);

    if(isUserExist.isNotEmpty){

      _isUserExist = true;

      _recipient =  isUserExist.first;

      _genderDP = User.userGenderDP(_recipient.gender);

      _statusColor = User.userStatusColor(_recipient.status);

      nickname = _recipient.nickname;

    }

    if(_message.messageStatus != '3'){

      final tmpData = {'type': 'seen', 'id': _message.messageId, 'time': DateTime.now().toUtc().millisecondsSinceEpoch};

      final String tmpDataEncode = jsonEncode(tmpData);

      final tmpInfo = TmpInfoModel(
                  tmpId: 'seen${_message.messageId}',
                  data: tmpDataEncode,
                  addTime: DateTime.now().toUtc().millisecondsSinceEpoch.toString(), 
                  status: '0',                 
              );

     User().saveTmpInfo(tmpInfo);


     final messageBox = MessagesBox.getData();

      final isMessageExist = messageBox.values.where((elementMessage) => elementMessage.messageId == _message.messageId);

      if(isMessageExist.isNotEmpty){

                final messageRow =  isMessageExist.first;

                messageRow.messageStatus = '3';
                messageRow.readAt = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
                messageRow.save();

      } 

    }

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left:6, right: 6),
      child: Column(
        children: [
          SizedBox(width: mq.width, height: mq.height * .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 2.5, 0.5, 0.5),
                child: (_isUserExist)?Text(nickname,
                style: TextStyle(fontSize: 12, color: _statusColor)):const Text('Unknown',
                style: TextStyle(fontSize: 12, color: senaryTextColor)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
                padding: const EdgeInsets.only(top:8),
                child:  CircleAvatar(
                  backgroundColor: _statusColor,
                radius: mq.height * .029,
                child: CircleAvatar(
                    radius: mq.height * .027,
                    backgroundImage: AssetImage(_genderDP),
                  ),
              ),
              ),
              SizedBox(width: 0.1),
              Flexible(
              child: Container(
                padding: EdgeInsets.all(_message.messageType == 'text'
                    ? mq.width * .02
                    : mq.width * .01),
                margin: EdgeInsets.symmetric(
                    horizontal: mq.width * .02, vertical: mq.height * .01),
                decoration: const BoxDecoration(
                    color: senaryTextColor,
                    //making borders curved
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
                child: _message.messageType == 'text'
                    ?
                    //show text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableLinkify(
                          contextMenuBuilder: (context, editableTextState) {
                              final List<ContextMenuButtonItem> buttonItems =
                                  editableTextState.contextMenuButtonItems;
                              buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
                                return buttonItem.type == ContextMenuButtonType.cut;
                              });
                              return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems: buttonItems,
                              );
                            }, 
                          onOpen: _onOpen,
                          text: _message.messageContent,
                          options: const LinkifyOptions(humanize: false),
                          style: const TextStyle(fontSize: 14, color: primaryTextColor),
                          linkStyle: const TextStyle(decoration: TextDecoration.none, fontSize: 14, color: secondaryLinkColor),
                          showCursor: true,
                          ),
                          SizedBox(height: mq.height * .005),
                           Text(localTime(_message.sentAt), 
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 11, color: mutedTextColor)),
                        ],
                      )
                    :
                    //show image
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: WidgetZoom(
                            closeFullScreenImageOnDispose: true, 
                            heroAnimationTag: 'chatGallery',
                            zoomWidget:CachedNetworkImage(
                              imageUrl: uploadUrl + _message.messageContent,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            )),
                          ),
                          SizedBox(height: mq.height * .005),
                           Text(localTime(_message.sentAt), 
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 11, color: mutedTextColor)),
                      ],
                    ),
              ),
            ),
            const SizedBox(width: 0.1),
              const Padding(
                padding: EdgeInsets.only(top:12),
                child: Icon(Icons.info_rounded, color: tertiaryTextColor, size: 15),
              ),
            ],
          ),
        ],
      ));

  }


 

  Widget _myMessage() {

    final int _id = widget.id;
    final _message= widget.message;
    final _selfInfo = widget.selfInfo;

    _genderDP = User.userGenderDP(_selfInfo.gender);

    Color _statusColor = User.userStatusColor(_selfInfo.status);

    Icon _messageStatusIcon = const Icon(Icons.timelapse, color: tertiaryTextColor, size: 15);

    if (_message.messageStatus == '1') {
    _messageStatusIcon = const Icon(Icons.done, color: tertiaryTextColor, size: 15);
    }else if (_message.messageStatus == '2') {
    _messageStatusIcon = const Icon(Icons.done_all_rounded, color: secondaryTextColor, size: 15);
     }else if (_message.messageStatus == '3') {
    _messageStatusIcon = const Icon(Icons.done_all_rounded, color: infoTextColor, size: 15);
    }

    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(left:6, right: 6),
      child: Column(
        children: [
          SizedBox(width: mq.width, height: mq.height * .01),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.5, 2.5, 5.0, 0.5),
                child: Text(_selfInfo.nickname,
                style: TextStyle(fontSize: 12, color: _statusColor)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:12),
                child: _messageStatusIcon,
              ),
              const SizedBox(width: 0.1),
              Flexible(
              child: Container(
                padding: EdgeInsets.all(_message.messageType == 'text'
                    ? mq.width * .02
                    : mq.width * .01),
                margin: EdgeInsets.symmetric(
                    horizontal: mq.width * .02, vertical: mq.height * .01),
                decoration: const BoxDecoration(
                    color: quinaryTextColor,
                    //making borders curved
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                        
                child: _message.messageType == 'text'
                    ?
                    //show text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SelectableLinkify(    
                          contextMenuBuilder: (context, editableTextState) {
                              final List<ContextMenuButtonItem> buttonItems =
                                  editableTextState.contextMenuButtonItems;
                              buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
                                return buttonItem.type == ContextMenuButtonType.cut;
                              });
                              return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems: buttonItems,
                              );
                            },                  
                          onOpen: _onOpen,
                          text: _message.messageContent,
                          options: const LinkifyOptions(humanize: false),
                          style: const TextStyle(fontSize: 14, color: activeTextColor),
                          linkStyle: const TextStyle(decoration: TextDecoration.none, fontSize: 14, color: primaryLinkColor),
                          showCursor: true,
                          ),
                           SizedBox(height: mq.height * .005),
                           Text(localTime(_message.sentAt), 
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 11, color: senaryTextColor)),
                        ],
                      )
                    :
                    //show image
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: WidgetZoom(
                            closeFullScreenImageOnDispose: true, 
                            heroAnimationTag: 'chatGallery',
                            zoomWidget:CachedNetworkImage(
                              imageUrl: uploadUrl + _message.messageContent,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, size: 70),
                            )),
                          ),
                           SizedBox(height: mq.height * .005),
                           Text(localTime(_message.sentAt), 
                          style: TextStyle(decoration: TextDecoration.none, fontSize: 11, color: mutedTextColor)),
                      ],
                    ),
              ),
            ),
            const SizedBox(width: 0.1),
              Padding(
                padding: const EdgeInsets.only(top:8),
                child:  CircleAvatar(
                  backgroundColor: _statusColor,
                radius: mq.height * .029,
                child: CircleAvatar(
                    radius: mq.height * .027,
                    backgroundImage: AssetImage(_genderDP),
                  ),
              ),
              ),
            ],
          ),
        ],
      ));

  }



}
