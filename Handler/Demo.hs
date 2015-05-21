module Handler.Demo where

import Import
import Yesod.Form.Bootstrap3 (BootstrapFormLayout (..), renderBootstrap3,
                              )

--Aform From Entity Demo
demoForm :: Maybe Demo -> AForm Handler Demo
demoForm   demo = Demo 
                <$> areq textField "fieldone" (demoFieldOne <$> demo)
                <*> areq intField "fieldTwo" (demoFieldTwo <$> demo) 
                <*> areq boolField "fieldThree" (demoFieldThree <$> demo) 
                <*> areq dayField "fieldFour" (demoFieldFour <$> demo) 

--CRUD 
--Create
getDemoNewR ::  Handler Html 
getDemoNewR = do 
               (widget, encoding) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ demoForm Nothing
               defaultLayout $ do
                    let actionR = DemoNewR                          
                    $(widgetFile "Demo/DemoCreate") 

postDemoNewR :: Handler Html
postDemoNewR = do
                ((result,widget), encoding) <- runFormPost $ renderBootstrap3 BootstrapBasicForm $ demoForm  Nothing
                case result of
                     FormSuccess demo -> do 
                                 _ <- runDB $ insert demo
                                 redirect DemoListR
                     _ -> defaultLayout $ do
                     let actionR = DemoNewR                
                     $(widgetFile "Demo/DemoCreate")


--Delete
deleteDemoDeleteR ::  DemoId -> Handler Html
deleteDemoDeleteR demoId = do
                            runDB $ delete demoId
                            redirect DemoListR

--Edit
getDemoEditR :: DemoId -> Handler Html
getDemoEditR demoId  = do
               demo <- runDB $ get404 demoId  
               (widget, encoding) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ demoForm  (Just demo)
               defaultLayout $ do
                   let actionR = DemoEditR demoId       
                   $(widgetFile "Demo/DemoCreate")

postDemoEditR :: DemoId -> Handler Html
postDemoEditR demoId  = do
                demo <- runDB $ get404 demoId
                ((result,widget), encoding) <- runFormPost $ renderBootstrap3 BootstrapBasicForm $ demoForm  (Just demo)
                case result of
                     FormSuccess demoResult -> do 
                                 _ <- runDB $ replace demoId  demoResult
                                 redirect DemoListR
                     _ -> defaultLayout $ do     
                     let actionR = DemoEditR demoId                           
                     $(widgetFile "Demo/DemoCreate") 


--List
getDemoListR ::  Handler Html
getDemoListR  = do
                    demos <- runDB $ selectList [] []
                    ( _ , _ ) <- generateFormPost $ renderBootstrap3 BootstrapBasicForm $ demoForm Nothing
                    defaultLayout $ do
                       $(widgetFile "Demo/DemoList")


{-



-- eliminar examen
deleteExamDeleteR ::  ExamId -> Handler Html
deleteExamDeleteR eid = do
                            runDB $ deleteCascade eid
                            redirect ListExamsR
-}