// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from './application'

import QuizModalController from './quiz_modal_controller'
application.register('quiz-modal', QuizModalController)

import ShareModalController from './question_modal_controller'
application.register('question-modal', ShareModalController)

import QuestionModalController from './share_modal_controller'
application.register('share-modal', QuestionModalController)

import FolderModalController from './folder_modal_controller'
application.register('folder-modal', FolderModalController)
