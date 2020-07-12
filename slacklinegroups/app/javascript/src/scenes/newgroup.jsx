import React, { useEffect, useState, useRef } from 'react';

import Paper from '@material-ui/core/Paper';

import GroupForm from '../components/form/GroupForm';
import ContentContainer from '../components/container/ContentContainer';
import Map from '../components/map/Map';
import Header from '../components/header/Header';

import MapManagerFactory from '../lib/map/MapManagerFactory';

const NewGroup = props => {
  const mapContainer = useRef(null);
  const [mapManager, setMapManager] = useState(null);

  useEffect(() => { if (!mapManager) setMapManager(MapManagerFactory.create(mapContainer)); }, [mapManager]);

  return (
    <React.Fragment>
      <Header showSiteName={true} />
      <ContentContainer size="large" className="belowHeaderContent">
        <p>
          To submit a new group for approval, fill out all fields and select a location for 
          your group on the map below.
        </p>
      </ContentContainer>
      <ContentContainer size="large" className="mapContent">
        <Paper elevation={1}>
          <Map ref={mapContainer} />
        </Paper>
      </ContentContainer>
      <ContentContainer size="large" className="formContent">
        <GroupForm csrf={props.csrf} />
      </ContentContainer>
    </React.Fragment>
  );
};

export default NewGroup;
