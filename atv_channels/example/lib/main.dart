import 'package:flutter/material.dart';
import 'dart:async';

import 'package:atv_channels/atv_channels.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements AtvChannelsApiFlutter {
  final api = AtvChannelsApi();
  Future<List<Channel>> channelsFuture;

  @override
  void initState() {
    super.initState();
    channelsFuture = api.getChannelsList();
    test();

    AtvChannelsApiFlutter.setup(this);
  }

  Future test() async {
    final init = await api.getInitialData();
    print('--- init ${init.channelExternalId} ${init.programExternalId}');

    final channels = await channelsFuture;
    print('--- channels.isEmpty ${channels.isEmpty}');
    int channelId;
    if (channels.isEmpty) {
      channelId = (await api.createChannel(CreateChannelRequest()
            ..externalId = 'movies'
            ..name = 'movies'
            ..logoDrawableResourceName = 'movies_channel'
            ..defaultChannel = true))
          .id;
      await api.createProgram(CreateProgramRequest()
        ..channelId = channelId
        ..channelExternalId = 'movies'
        ..externalId = 'tt7998848'
        ..type = 0
        ..description =
            'Что если можно было бы отмотать свою жизнь на 25 лет назад, заново пережить все самые яркие события и получить заряд ностальгии? Когда Максу в 13 лет подарили его первую видеокамеру, он не мог представить, что это положит начало невероятно трогательной, смешной и такой знакомой всем нам хронике от 90-х до 2010-х.'
        ..posterArtAspectRatio = 4
        ..posterArtUri =
            'http://image.tmdb.org/t/p/w300/yI6Mv8ckjx2k2tmDy0GF3ruWm3n.jpg'
        ..releaseDate = '2019-09-04'
        ..reviewRating = '3.6'
        ..reviewRatingStyle = 0
        ..title = 'Жизнь на перемотке');
      await api.createProgram(CreateProgramRequest()
        ..channelId = channelId
        ..channelExternalId = 'movies'
        ..externalId = 'tt7420342'
        ..type = 0
        ..description =
            'Главный герой занимается отмыванием денег в Нью-Йорке. После автоаварии он приходит в себя и понимает, что у него нет воспоминаний о прошлом, зато есть миллионы долларов наличными и наркотики. Теперь молодому человеку предстоит искать ответы на многочисленные вопросы, бороться с бандой продажных копов и попробовать разобраться, кто он такой.'
        ..posterArtAspectRatio = 4
        ..posterArtUri =
            'http://image.tmdb.org/t/p/w300/wWpbW893AGmSBbFdACjY0xllw7D.jpg'
        ..releaseDate = '2019-08-08'
        ..reviewRating = '2.7'
        ..reviewRatingStyle = 0
        ..title = 'Киллер');
    } else {
      channelId = channels[0].id;
    }

    final programs = await api
        .getProgramsIdsList(GetProgramsIdsRequest()..channelId = channelId);
    print('---- programs ${programs.join(';')}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<List<Channel>>(
          future: channelsFuture,
          builder: (_, snapshot) {
            print('++++++++++++++  ${snapshot.connectionState}');
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData) {
              return Center(child: Text('Loading'));
            }
            return ListView(
              children: snapshot.data
                  .map((e) => ListTile(
                        title: Text(
                            '${e.title} ${e.id} ${e.externalId} ${e.isBrowsable}'),
                        onTap: () => api.setChannelBrowsable(
                            SetChannelBrowsableRequest()..id = e.id),
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            channelsFuture = api.getChannelsList();
          }),
        ),
      ),
    );
  }

  @override
  void showChannel(ShowRequest arg) {
    print(
        'showChannel============= ${arg.channelExternalId} ${arg.programExternalId}');
  }

  @override
  void showProgram(ShowRequest arg) {
    print(
        'showProgram============= ${arg.channelExternalId} ${arg.programExternalId}');
  }
}
