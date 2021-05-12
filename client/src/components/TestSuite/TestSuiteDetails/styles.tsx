import { makeStyles, Theme } from '@material-ui/core/styles';

export default makeStyles((theme: Theme) => ({
  root: {
    backgroundColor: theme.palette.background.paper,
  },
  testSuiteDetailsPanel: {
    flexGrow: 3,
    height: 'fit-content',
    width: '750px',
  },
  testIcon: {
    minWidth: '30px',
    display: 'inline-flex',
  },
  descriptionCardHeader: {
    padding: '16px 24px',
    fontWeight: 600,
    fontSize: '14px',
  },
  testGroupCardHeader: {
    padding: '8px 15px',
    fontWeight: 600,
    fontSize: '16px',
    border: '1px solid #c8e1ff',
    backgroundColor: '#f1f8ff',
    borderTopLeftRadius: '4px',
    borderTopRightRadius: '4px',
    display: 'flex',
    lineHeight: '31px',
  },
  testGroupCard: {
    marginBottom: '25px',
  },
  listItem: {
    borderBottom: '1px solid rgba(0,0,0,.12)',
  },
  testGroupCardList: {
    padding: 0,
  },
  testGroupCardHeaderResult: {
    marginRight: '10px',
    alignItems: 'center',
    display: 'inline-flex',
    width: '24px',
  },
  testGroupCardHeaderText: {
    flexGrow: 1,
  },
  descriptionPanel: {
    padding: '15px',
    overflow: 'auto',
  },
}));
