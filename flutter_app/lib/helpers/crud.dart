import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';


class DataServices{

  Future getValue(inputKey) async{
    var dataBox = Hive.box('data');
    return dataBox.get(inputKey);

  }

  Future saveValue(inputKey, inputValue) async{

    var dataBox = Hive.box('data');
    dataBox.put(inputKey, inputValue);
    return dataBox.put(inputKey, inputValue);

  }

  Future removeEntry(inputKey) async{

    var dataBox = Hive.box('data');
    return dataBox.delete(inputKey);

  }

}


class PreferencesServices {

  Future saveValue(inputKey, inputValue, inputType) async{

    final preferences = await SharedPreferences.getInstance();
    if(inputType == 'int'){

    await preferences.setInt(inputKey, inputValue);

    }else if(inputType == 'bool'){

    await preferences.setBool(inputKey, inputValue);

    }else if(inputType == 'double'){

    await preferences.setDouble(inputKey, inputValue);

    }else if(inputType == 'list'){

    await preferences.setStringList(inputKey, inputValue);

    }else if(inputType == 'string'){

    await preferences.setString(inputKey, inputValue);

    }

  }

  Future getValue(inputKey, inputType) async{

    final preferences = await SharedPreferences.getInstance();

    if(inputType == 'int'){

    final getResult = preferences.getInt(inputKey) ?? 0;

    return getResult;

    }else if(inputType == 'bool'){

    final getResult = preferences.getBool(inputKey) ?? false;

    return getResult;

    }else if(inputType == 'double'){

    final getResult = preferences.getDouble(inputKey) ?? 0;

    return getResult;

    }else if(inputType == 'list'){

    final getResult = preferences.getStringList(inputKey) ?? [];

    return getResult;

    }else if(inputType == 'string'){

    final getResult = preferences.getString(inputKey) ?? '';

    return getResult;

    }

  }

  Future removeEntry(inputKey) async{

    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(inputKey);

  }
  

}