class EventBar
  def clearBar
    print("\e[1;1H\e[2K")
  end
  def moveToBar
    print("\e[1;1H")
  end
  def writeBar(text)
    print("\e[1;1H#{text}")
  end
  def getBar(text)
    print("\e[1;1H\e[2K")
    print("\e[1;1H#{text}")
  end
end