require 'rails_helper'

RSpec.describe RouteService do
  describe '#get_route' do
    let(:route_service) { described_class.new }

    context 'when the API call is successful' do
      let(:from) { 'New York, NY' }
      let(:to) { 'Los Angeles, CA' }
      let(:expected_response) do
        {
      route: {
        sessionId: "ABcB_v___wUAAQAoAgAAeNpj0GBiYGJgYGDPSC1KtUrO7Z9UJgnkMnxOt6zn4LXKiveef-tzDIz2AdI7gDQDDvAfCGAmmf7_IQUSY8wJkWDgnS_0SjvZ2TwCRu8A0k1AGp9JINp4pfhiMR4gg8Nh5S4FBgUGLyBbEIgdYCo5uBQYHEBeYAMSjBwcDBwcQAYLSIqFwQFIMzJ0NIBIDNCAwmOCsxwMQIoF4KICDBxgYQEWFA0cCCZQQglZygDkOsYeMLsQLiqA3atMyByIM1kcwM6GiyqC3OqC7GYHuBuALAcHFiag4YzMDAwaLCxMDhAFjA3wQAJaISAAUQ-yoAndLTAnsMB9eADqPSYesDaDwI8MAFPnO1lhqw0k:car",
        realTime: 142695,
        distance: 2791.9276,
        time: 139638,
        formattedTime: "38:47:18",
        hasHighway: true,
        hasTollRoad: true,
        hasBridge: true,
        hasSeasonalClosure: false,
        hasTunnel: true,
        hasFerry: false,
        hasUnpaved: false,
        hasTimedRestriction: false,
        hasCountryCross: false,
        legs: [
          {
            index: 0,
            hasTollRoad: true,
            hasHighway: true,
            hasBridge: true,
            hasUnpaved: false,
            hasTunnel: true,
            hasSeasonalClosure: false,
            hasFerry: false,
            hasCountryCross: false,
            hasTimedRestriction: false,
            distance: 2791.9276,
            time: 142695,
            formattedTime: "39:38:15",
            origIndex: 0,
            origNarrative: "",
            destIndex: 0,
            destNarrative: "",
            maneuvers: [
              {
                index: 0,
                distance: 0.0516,
                narrative: "Head toward Church St on Chambers St. Go for 272 ft.",
                time: 18,
                direction: 2,
                directionName: "Northwest",
                signs: [],
                maneuverNotes: [],
                formattedTime: "00:00:18",
                transportMode: "car",
                startPoint: {
                  lat: 40.714532,
                  lng: -74.007119
                },
                turnType: 0,
                attributes: 0,
                iconUrl: "",
                streets: ["Chambers St"],
                mapUrl: "https://www.mapquestapi.com/staticmap/v5/map?key=TdBfKzgszEtwFrgxdsvEtsDUVZeyAJow&size=225,160&locations=40.714532,-74.007119|marker-1||40.7149,-74.00797|marker-2||&center=40.714715999999996,-74.0075445&defaultMarker=none&zoom=16&session=ABcB_v___wUAAQAoAgAAeNpj0GBiYGJgYGDPSC1KtUrO7Z9UJgnkMnxOt6zn4LXKiveef-tzDIz2AdI7gDQDDvAfCGAmmf7_IQUSY8wJkWDgnS_0SjvZ2TwCRu8A0k1AGp9JINp4pfhiMR4gg8Nh5S4FBgUGLyBbEIgdYCo5uBQYHEBeYAMSjBwcDBwcQAYLSIqFwQFIMzJ0NIBIDNCAwmOCsxwMQIoF4KICDBxgYQEWFA0cCCZQQglZygDkOsYeMLsQLiqA3atMyByIM1kcwM6GiyqC3OqC7GYHuBuALAcHFiag4YzMDAwaLCxMDhAFjA3wQAJaISAAUQ-yoAndLTAnsMB9eADqPSYesDaDwI8MAFPnO1lhqw0k:car"
              },
              {
                index: 1,
                distance: 0.2715,
                narrative: "Turn right onto Church St. Go for 0.3 mi.",
                time: 86,
                direction: 3,
                directionName: "Northeast",
                signs: [],
                maneuverNotes: [],
                formattedTime: "00:01:26",
                transportMode: "car",
                startPoint: {
                  lat: 40.7149,
                  lng: -74.00797
                },
              }
            ]
            
          }
        ]
      }
      }
      end

      before do
        allow(route_service).to receive(:get_url).and_return(expected_response)
      end

      it 'returns the route information' do
        response = route_service.get_route(from, to)
        expect(response).to include(expected_response)
      end
    end

  end
end
