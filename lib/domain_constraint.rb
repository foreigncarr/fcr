module DomainConstraint
  class MySuperCar
    MY_SUPER_CAR_DOMAIN = 'mysupercar'

    def matches?(request)
      request.host.include? MY_SUPER_CAR_DOMAIN
    end
  end

  class MySuperVan
    MY_SUPER_VAN_DOMAIN = 'mysupervan'

    def matches?(request)
      request.host.include? MY_SUPER_VAN_DOMAIN
    end
  end
end
