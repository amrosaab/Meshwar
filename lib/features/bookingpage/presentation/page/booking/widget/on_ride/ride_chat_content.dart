import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/app_colors.dart';
import '../../../../../../../common/ride_visuals.dart';
import '../../../../../../../l10n/app_localizations.dart';

class RideChatMessage {
  const RideChatMessage(
      {required this.id,
      required this.text,
      required this.timestamp,
      required this.isMine,
      this.delivered = false,
      this.seen = false});
  final String id, text, timestamp;
  final bool isMine, delivered, seen;
}

/// The booking bloc owns message transport; this widget owns presentation.
class RideChatContent extends StatefulWidget {
  const RideChatContent(
      {super.key,
      required this.driverName,
      required this.avatarUrl,
      required this.vehicleName,
      required this.vehiclePlate,
      required this.messages,
      required this.inputController,
      required this.scrollController,
      required this.onBack,
      this.onCall,
      this.onSend});
  final String driverName, avatarUrl, vehicleName, vehiclePlate;
  final List<RideChatMessage> messages;
  final TextEditingController inputController;
  final ScrollController scrollController;
  final VoidCallback onBack;
  final VoidCallback? onCall;
  final ValueChanged<String>? onSend;

  @override
  State<RideChatContent> createState() => _RideChatContentState();
}

class _RideChatContentState extends State<RideChatContent> {
  @override
  void didUpdateWidget(covariant RideChatContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.lastOrNull?.id == oldWidget.messages.lastOrNull?.id &&
        widget.messages.length == oldWidget.messages.length) {
      return;
    }
    final scroll = widget.scrollController;
    // Don't pull someone reading history back down on every ride refresh.
    // New messages follow only when near the latest message or after sending.
    if (!scroll.hasClients ||
        scroll.offset < 100 ||
        widget.messages.lastOrNull?.isMine == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !scroll.hasClients) return;
        scroll.animateTo(0,
            duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
      });
    }
  }

  void _send() {
    final message = widget.inputController.text.trim();
    if (message.isEmpty || widget.onSend == null) return;
    widget.onSend!(message);
    widget.inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = _ChatColors(context);
    final base = Theme.of(context).textTheme.bodyMedium!.copyWith(
        fontSize: 14,
        height: 1.5,
        color: colors.ink,
        fontWeight: FontWeight.w400);
    Text text(String value,
            {double size = 14,
            Color? color,
            FontWeight weight = FontWeight.w400,
            int? lines,
            TextAlign? align}) =>
        Text(value,
            maxLines: lines,
            textAlign: align,
            overflow: lines == null ? null : TextOverflow.ellipsis,
            style: base.copyWith(
                fontSize: size, color: color, fontWeight: weight));
    final scale = MediaQuery.textScalerOf(context);
    final headerHeight = (scale.scale(16) + scale.scale(12)) * 1.5 + 24;
    final vehicleHeight = scale.scale(12) * 1.5 + 23;
    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: headerHeight.clamp(80, double.infinity),
        titleSpacing: 0,
        title: Row(children: [
          IconButton(
              tooltip: l10n.back,
              onPressed: widget.onBack,
              icon:
                  Icon(Icons.arrow_back_rounded, size: 22, color: colors.ink)),
          _DriverAvatar(url: widget.avatarUrl, colors: colors),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                text(widget.driverName,
                    size: 16, weight: FontWeight.w700, lines: 1),
                const SizedBox(height: 2),
                text(l10n.driver, size: 12, color: colors.muted),
              ])),
          if (widget.onCall != null)
            Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, end: 16),
                child: Container(
                    decoration: BoxDecoration(
                        gradient: RideVisuals.green,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: RideVisuals.glow(AppColors.routeGreen)),
                    child: IconButton.filledTonal(
                        tooltip: l10n.rideCall,
                        onPressed: widget.onCall,
                        style: IconButton.styleFrom(
                            minimumSize: const Size(44, 44),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        icon: const Icon(Icons.phone_outlined, size: 21))))
          else
            const SizedBox(width: 16),
        ]),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                widget.vehicleName.isEmpty && widget.vehiclePlate.isEmpty
                    ? 1
                    : vehicleHeight),
            child: Column(children: [
              if (widget.vehicleName.isNotEmpty ||
                  widget.vehiclePlate.isNotEmpty)
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(children: [
                      const RideColorBadge(
                          icon: Icons.directions_car_outlined,
                          gradient: RideVisuals.blue,
                          size: 28,
                          iconSize: 16,
                          radius: 9),
                      const SizedBox(width: 8),
                      Expanded(
                          child: text(widget.vehicleName,
                              size: 12, color: colors.muted, lines: 1)),
                      if (widget.vehiclePlate.isNotEmpty)
                        Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * .32),
                            margin: const EdgeInsetsDirectional.only(start: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: colors.canvas,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: colors.border)),
                            child: text(widget.vehiclePlate,
                                size: 12, weight: FontWeight.w600, lines: 1)),
                    ])),
              Divider(height: 1, thickness: 1, color: colors.border),
            ])),
      ),
      body: Column(children: [
        Expanded(
            child: widget.messages.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(32),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              height: 76,
                              width: 76,
                              decoration: BoxDecoration(
                                  gradient: RideVisuals.blue,
                                  boxShadow:
                                      RideVisuals.glow(const Color(0xFF3A72D4)),
                                  borderRadius: BorderRadius.circular(26)),
                              child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: Colors.white,
                                  size: 32)),
                          const SizedBox(height: 20),
                          text(l10n.noMessagesHere,
                              size: 18,
                              weight: FontWeight.w700,
                              align: TextAlign.center),
                          const SizedBox(height: 8),
                          text(l10n.typeMessage,
                              color: colors.muted, align: TextAlign.center),
                        ])))
                : ListView.builder(
                    controller: widget.scrollController,
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, reversedIndex) {
                      final index = widget.messages.length - 1 - reversedIndex;
                      final message = widget.messages[index];
                      return _MessageBubble(
                          key: ValueKey(message.id),
                          message: message,
                          grouped: index > 0 &&
                              widget.messages[index - 1].isMine ==
                                  message.isMine,
                          colors: colors,
                          base: base);
                    })),
        Container(
            decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.border))),
            child: SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                      child: TextField(
                          controller: widget.inputController,
                          enabled: widget.onSend != null,
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          cursorColor: colors.accent,
                          style: base,
                          decoration: InputDecoration(
                              hintText: l10n.typeMessage,
                              hintStyle: base.copyWith(color: colors.muted),
                              filled: true,
                              fillColor: colors.canvas,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 13),
                              enabledBorder: _inputBorder(colors.border),
                              focusedBorder:
                                  _inputBorder(colors.accent, width: 1.3),
                              disabledBorder: _inputBorder(colors.border)))),
                  const SizedBox(width: 10),
                  ValueListenableBuilder<TextEditingValue>(
                      valueListenable: widget.inputController,
                      builder: (context, value, _) => Container(
                          decoration: BoxDecoration(
                              gradient: value.text.trim().isNotEmpty &&
                                      widget.onSend != null
                                  ? RideVisuals.rose
                                  : null,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: value.text.trim().isNotEmpty &&
                                      widget.onSend != null
                                  ? RideVisuals.glow(AppColors.meshwarRed)
                                  : null),
                          child: IconButton.filled(
                              tooltip: l10n.send.trim(),
                              onPressed: value.text.trim().isEmpty || widget.onSend == null
                                  ? null
                                  : _send,
                              style: IconButton.styleFrom(
                                  minimumSize: const Size(48, 48),
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: colors.border,
                                  disabledForegroundColor: colors.muted,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              icon: const Icon(Icons.arrow_upward_rounded, size: 23)))),
                ]))),
      ]),
    );
  }

  OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: color, width: width));
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble(
      {super.key,
      required this.message,
      required this.grouped,
      required this.colors,
      required this.base});
  final RideChatMessage message;
  final bool grouped;
  final _ChatColors colors;
  final TextStyle base;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    final alignment = mine
        ? AlignmentDirectional.centerEnd
        : AlignmentDirectional.centerStart;
    return Padding(
        padding: EdgeInsets.only(top: grouped ? 6 : 18),
        child: Align(
            alignment: alignment,
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: (MediaQuery.sizeOf(context).width - 40) * .84),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
                    decoration: BoxDecoration(
                        gradient: mine
                            ? RideVisuals.rose
                            : RideVisuals.wash(
                                context, const Color(0xFF3A72D4)),
                        boxShadow: RideVisuals.glow(
                            mine
                                ? AppColors.meshwarRed
                                : const Color(0xFF3A72D4),
                            strength: mine ? .12 : .06),
                        border: mine ? null : Border.all(color: colors.border),
                        borderRadius: BorderRadiusDirectional.only(
                            topStart: const Radius.circular(20),
                            topEnd: const Radius.circular(20),
                            bottomStart: Radius.circular(mine ? 20 : 6),
                            bottomEnd: Radius.circular(mine ? 6 : 20))),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(message.text,
                              style: base.copyWith(
                                  color: mine ? Colors.white : colors.ink)),
                          const SizedBox(height: 5),
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            Flexible(
                                child: Text(message.timestamp,
                                    style: base.copyWith(
                                        fontSize: 10,
                                        color: mine
                                            ? Colors.white.withValues(alpha: .8)
                                            : colors.muted))),
                            if (mine) ...[
                              const SizedBox(width: 5),
                              Icon(
                                  message.delivered || message.seen
                                      ? Icons.done_all_rounded
                                      : Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white.withValues(
                                      alpha: message.seen ? 1 : .65)),
                            ],
                          ]),
                        ])))));
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.url, required this.colors});
  final String url;
  final _ChatColors colors;
  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.person_rounded, size: 26, color: Colors.white);
    return Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
            gradient: RideVisuals.blue,
            boxShadow: RideVisuals.glow(const Color(0xFF3A72D4)),
            borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: url.isEmpty
            ? fallback
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback));
  }
}

class _ChatColors {
  _ChatColors(BuildContext context)
      : dark = Theme.of(context).brightness == Brightness.dark;
  final bool dark;
  Color get canvas => dark ? AppColors.bgVoid : AppColors.lightBg;
  Color get surface => dark ? AppColors.bgAsphaltLight : Colors.white;
  Color get ink => dark ? const Color(0xFFF8F5F7) : const Color(0xFF201B25);
  Color get muted => dark ? const Color(0xFFBAADB9) : const Color(0xFF79717C);
  Color get border => dark ? const Color(0xFF382B3B) : const Color(0xFFECE9EE);
  Color get accent => dark ? AppColors.signalRose : AppColors.meshwarRed;
}
