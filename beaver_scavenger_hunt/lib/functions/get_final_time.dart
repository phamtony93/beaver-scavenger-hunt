String getFinalTime(DateTime beginTime, DateTime endTime)  {
    
    Duration difference;
    difference = endTime.difference(beginTime);

    String time = (difference.inHours).toString().padLeft(2, '0') + 
        ':' + (difference.inMinutes%60).toString().padLeft(2, '0') + 
        ':' + (difference.inSeconds%60).toString().padLeft(2, '0');
    return time;
  }