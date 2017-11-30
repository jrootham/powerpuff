import PropTypes from 'prop-types';
import React from 'react';
import HighSchoolDeckContainer from './HighSchoolDeckContainer'
import CardContainer from './CardContainer'

export default class DecksContainer extends React.Component {
  static propTypes = {};

  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    console.log('DECKS CONTAINER', this.props)
    const hs_options = ['grade_9', 'grade_10', 'grade_11', 'grade_12']
    return (
      <div className="decks-container">
        <CardContainer options={ hs_options } content={'highSchool'} { ...this.props } />
        <CardContainer options={ this.props.post_secondary } content={'postSecondary'} { ...this.props }/>
        <CardContainer options={ this.props.occupation } content={'occupation'} { ...this.props } />
      </div>
    );
  }
}
